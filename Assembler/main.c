#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>

//array size for input buffer
#define bufferSize 100

//opcode types for operand identification
#define IMMEDIATE 1
#define REGISTER 2
#define MEMORY 3
#define JUMP 4

//pointers for IO files
FILE *fpIn;
FILE *fpOut;

int main(int argc, char *argv[]) //main takes 2 arguments, both are names of the in- and output files respectively
{
	//the buffer array is used to store either the arguments of main or filenames input from the user.
	//This is because the program can be run from a command line with arguments or as a .exe without.
	char buffer[3][100];
	int memoryDepth = 1024;
	//The arguments are counted in argc and if there are 2 (3 because argc counts as an argument)
	//normal execution will occur. Else the program will prompt for input or exit
	if (argc == 1)
	{
		printf("Zero arguments given...");
		printf("\nDid you run the program as .exe? Y/N: ");

		if (getchar() == 'y' || getchar() == 'Y')
		{
			printf("\nWould you like to give arguments now? Y/N: ");
			getchar();
			
			if (getchar() == 'y' || getchar() == 'Y')
			{
				printf("\nWrite <input-filename.extension>: ");
				getchar();
				fgets(buffer[0], 100, stdin);
				printf("\nWrite <output-filename.extension>: ");
				fgets(buffer[1], 100, stdin);
				printf("\nWrite <memory depth>: ");
				fgets(buffer[2], 100, stdin);

				strtok(buffer[0], "\n");
				strtok(buffer[1], "\n");
				strtok(buffer[2], "\n");
				memoryDepth = atoi(buffer[2]);
			}
			else
			{
				printf("Press enter to exit...");
				getchar();
				return(0);
			}
		}
		else
		{
			printf("No? Try again with more arguments.\nPress enter to exit...");
			getchar();
			return(0);
		}


	}
	else if (argc == 2)
	{
		printf("Argument given is: %s. One more argument is needed.\n", argv[1]);
		getchar();
		return(0);
	}
	else if (argc == 3)
	{
		printf("Arguments given are: %s & %s.\nDefault memory depth will be used (1024)\n", argv[1], argv[2]);
		strcpy(buffer[0], argv[1]);
		strcpy(buffer[1], argv[2]);
	}
	else if (argc == 4)
	{
		printf("Arguments given are: %s, %s & %s.\n", argv[1], argv[2], argv[3]);
		strcpy(buffer[0], argv[1]);
		strcpy(buffer[1], argv[2]);
		strcpy(buffer[2], argv[3]);

		memoryDepth = atoi(buffer[2]);
		if (memoryDepth <= 0)
		{
			printf("Memeory depth is not a number.\nPress enter to exit...");
			getchar();
			return(0);
		}
		else
		{
			printf("Memeory depth will be %d.\n", memoryDepth);
		}
	}
	else
	{
		printf("Too many arguments given...\nPress enter to exit...");
		getchar();
		return(0);
	}
	
	char temp[bufferSize]; //temporary input array for reading a line of assembly code at a time
	int opCount; //used to count the number of operands in a given line to make is less "hard coded"
	int opcType; //used to define what type of opcode is read
	int lineCount = 0; //used to keep track of label/jump locations as well as outputting to .mif format
	
	char labelName[100][50]; //array used to store label names
	int labelLine[100]; //array used to store the linenumber corresponding to a given label name
	int labelindex = 0; //every time a label is stored, the index of where to store the next label increments
	bool label; //used to keep track of if a line contains a label

	int outputIndex = 0; // This is used to determine where in the output array the next output is stored.
	int outputType = 0; // This is used to determine what order to print the output in.
	char output[7][17];// Array with all outputs. used to output in different order depending on opcode type and special cases
	int immMem = 0; //used to keep track of a specific case for memory addresses which contain $rs+imm
	
	int regJump = 0;
	fpIn = fopen(buffer[0], "r"); //opens input file in read-only mode

	if (!fpIn) //read file doesnt exist
	{
		printf("Read file does not exist.\nPress enter to exit...");
		getchar();
		return(0);
	}

#pragma region LabelFinder
	//Finds all labels before actual assembly occurs which allows for jumps in the actual assembly
	while (1)
	{
		if (!fgets(temp, bufferSize, fpIn))//end of file
		{
			lineCount = 0; //resets linecount for use in assembly stage
			printf("%d label(s) were found\n", labelindex); //mostly for debugging
			printf("Label-check done...\n\n");
			break;
		}
		
		for (int i = 0; i < bufferSize; i++) //comment remover
		{
			if (temp[i] == '/' && temp[i + 1] == '/') //comment is found and replaced by a new line and stringend
			{
				temp[i] = '\n';
				temp[i + 1] = '\0';
				break;
			}
		}

		if (strstr(temp, ":")) //if temp contains ":" then a label is present and it's name and line number is saved
		{
			for (int i = 0; i < bufferSize; i++)
			{
				if (temp[i] == ':')
				{
					break;
				}
				labelName[labelindex][i] = temp[i];
				labelName[labelindex][i + 1] = '\0';
				strcat(labelName[labelindex], " "); //appends a space to the end of labelname in case two labels start with the same name.
													// eg. label and label1. both would contain "label" but not "label "
			}
			labelLine[labelindex] = lineCount;
			labelindex++;
		}
		if (temp[0] != '\n' && !strstr(temp,":")) //if the line is not a newline or contains a label, linecount is incremented
		{
			lineCount++;
		}
		
	}
#pragma endregion

	fclose(fpIn); //closes input file to reopen it from the beginning
	fpIn = fopen(buffer[0], "r"); //opens input file in read only mode

	if (!fpIn) //read file doesnt exist
	{
		printf("Read file does not exist...");
		getchar();
		return(0);
	}

	fpOut = fopen(buffer[1], "r"); //opens output file in read mode, this is to check if it exists
	
	if (!fpOut) //read file doesnt exist, asks if user would like to create file
	{
		printf("Write file does not exist. Create write file? Y/N: ");
		if (getchar() == 'y' || getchar() == 'Y') //create file
		{
			fpOut = fopen(buffer[1], "w");
		}
		else //exit program
		{
			printf("Press enter to exit...");
			getchar();
			return(0);
		}
		
	}
	else //if file exists, open file in write only mode.
	{
		fpOut = fopen(buffer[1], "w");
	}

#pragma region MIF prep
	//outputs to the start of the outputfile. These lines are needed to load a .mif onto the cpu
	fprintf(fpOut, "DEPTH = %d;\n", memoryDepth);
	fprintf(fpOut, "WIDTH = 32;\n");
	fprintf(fpOut, "ADDRESS_RADIX = UNS;\n");
	fprintf(fpOut, "DATA_RADIX = BIN;\n\n");
	fprintf(fpOut, "CONTENT\n");
	fprintf(fpOut, "BEGIN\n\n");
#pragma endregion

	while (1)
	{
		strcpy(output[5], "00000");  //used to pad output with 5 zeros
		strcpy(output[6], "000000");  //used to pad output with 6 zeros
		
		label = false; //resets if line contains label
		opCount = 0; //clears operandCount
		
		for (int i = 0; i < bufferSize; i++)
		{
			temp[i] = '\0'; //clears temp since fgets does not 
		}

		if (!fgets(temp, bufferSize, fpIn))//reads a line from the input file for a maximum of 100 chars. breaks if no line is read
		{
			break; //breaks the while loop if no more lines are present in input file
		}
		 
		strcat(temp, " "); //adds space at the end of line to allow operandFinder to work properly if line doesnt end with ' ' or '\n'
		
		for (int i = 0; i < bufferSize; i++) //replaces all new lines with spaces since spaces are used to find operands
		{
			if (temp[i] == '\n')
			{
				temp[i] = ' ';
				break;
			}
		}

#pragma region commentFinder
		//checks temp for comments and replaces the comment with two spaces and a string end.
		//also replaces the rest of the string with char \0, which is the string terminator char.
		for (int i = 0; i < bufferSize; i++)
		{
			if (temp[i] == '/' && temp[i + 1] == '/')
			{
				//printf("comment found"); //debugging
				for (int u = i; u < bufferSize-i; u++)
				{
					temp[u] = '\0';
				}
				temp[i] = ' ';
				temp[i + 1] = ' ';
				temp[i + 2] = '\0';
				break;
			}
		}
#pragma endregion

#pragma region labelFinder
		//Checks for labels in the input array and sets the label bool to true.
		//This ensures that the line is ignore in assembly
		if (strstr(temp, ":"))
		{
			printf("Label Found");
			label = true;
			opcType = 0;
		}
#pragma endregion
		
#pragma region MIF LinePrint
		//outputs some required syntax for .mif format before the actual binary opcode
		for (int i = 0; i < bufferSize; i++)
		{
			if (temp[i] != ' ' && temp[i] != '\n' && temp[i] != '\0' && temp[i] != 9)
			{
				opcType = 5;
				break;
			}
			else
			{
				opcType = 0;
			}
		}

		if (temp[0] == ' ' && temp[1] == ' ' && temp[2] == '\0') //checks for empty line
		{
			opcType = 0;
		}
		if (temp[0] == '\0') //checks for empty string as well
		{
			opcType = 0;
		}
		//else if (label == false) //if no label exists, the opcode type is set to non zero but not 1-4
		//{
		//	opcType = 5;
		//}

		if (label == false && opcType != 0) // if opcode is present, outputs required syntax
		{
			//allows for cleaner formatting of output 
			if (lineCount < 10)
			{
				fprintf(fpOut, "%d   :   ", lineCount);
			}
			else if (lineCount < 100)
			{
				fprintf(fpOut, "%d  :   ", lineCount);
			}
			else if (lineCount < 1000)
			{
				fprintf(fpOut, "%d :   ", lineCount);
			}
			else if (lineCount < 10000)
			{
				fprintf(fpOut, "%d:   ", lineCount);
			}
		}
#pragma endregion
				
#pragma region opcodeFinder

#pragma region opcArr
		//array that contains all opcodes. used for comparison with input
		char opcArr[100][15]; 
		strcpy(opcArr[0], "ADDI "); //ADD immediate
		strcpy(opcArr[1], "SUBI "); //substract immediate
		strcpy(opcArr[2], "ADDCI "); // Add carry immediate
		strcpy(opcArr[3], "NEGI "); // Negate immediate
		strcpy(opcArr[4], "ANDI "); // and immediate
		strcpy(opcArr[5], "XORI "); // XOR immediate
		strcpy(opcArr[6], "ORI "); // or immediate
		strcpy(opcArr[7], "MULTI "); // multiply immediate
		strcpy(opcArr[8], "LSLI "); // logic shift left immediate
		strcpy(opcArr[9], "LSRI "); // Logic shift Right immediate
		strcpy(opcArr[10], "RASI "); // right arithmetic shift immediate
		strcpy(opcArr[11], "CMPI "); // compare immediate
		strcpy(opcArr[12], "MOVI "); // Move immediate

		strcpy(opcArr[13], "ADDR "); // ADD register
		strcpy(opcArr[14], "ADDC "); // ADD carry
		strcpy(opcArr[15], "SUBR "); // substract register
		strcpy(opcArr[16], "NEGR "); // NEGATE register
		strcpy(opcArr[17], "ANDR "); // AND register
		strcpy(opcArr[18], "XORR "); // XOR register
		strcpy(opcArr[19], "ORR "); // OR register
		strcpy(opcArr[20], "MULT "); // Multiply register
		strcpy(opcArr[21], "LSLR "); // Logic shift Left register
		strcpy(opcArr[22], "LSRR "); // Logic shift right register
		strcpy(opcArr[23], "RASR "); // right arithmetic shift register
		strcpy(opcArr[24], "CMP "); // compare Register
		strcpy(opcArr[25], "MOV "); // Move Register

		strcpy(opcArr[26], "JMP "); // Jump label
		strcpy(opcArr[27], "JMPNQ "); // jump NOT EQUAL TO
		strcpy(opcArr[28], "JMPLE "); // Jump Less label
		strcpy(opcArr[29], "JMPEQ "); // Jump equal label

		strcpy(opcArr[30], "NOP "); // No operation 
		
		strcpy(opcArr[31], "LOAD "); // Load 
		strcpy(opcArr[32], "STORE "); // store
		strcpy(opcArr[33], "POP "); // POP
		strcpy(opcArr[34], "PUSH "); // Push

		strcpy(opcArr[35], "HALT "); // HALT

		strcpy(opcArr[36], "FIRCOR "); // FIRCOR
		strcpy(opcArr[37], "FIRCOI "); // FIRCOI
		strcpy(opcArr[38], "FIRSAR "); // FIRSAR
		strcpy(opcArr[39], "FIRSAI "); // FIRSARI
		strcpy(opcArr[40], "FIRCORESET "); // FIRCORESET

		strcpy(opcArr[41], "JMPR "); // Jump Register
		strcpy(opcArr[42], "JMPNQR "); // jump not equal to register
		strcpy(opcArr[43], "JMPLER "); // Jump Less Register
		strcpy(opcArr[44], "JMPEQR "); // Jump equal Register
		strcpy(opcArr[45], "JMPPA "); // Jump parity immediate
		strcpy(opcArr[46], "JMPPAR "); // Jump parity Register

		strcpy(opcArr[47], "GETFLAG "); // get flags to reg
		strcpy(opcArr[48], "SETFLAG "); // set flags immediate
		strcpy(opcArr[49], "PUSHFLAGS "); // push flags
		strcpy(opcArr[50], "POPFLAGS "); // pop flags
		strcpy(opcArr[51], "SETFLAGR "); // set flags from register
#pragma endregion

#pragma region opcArrBin
		//opcodes written in binary for each corresponding opcode
		char opcArrBin[100][10]; 
		strcpy(opcArrBin[0], "001101"); // ADDI
		strcpy(opcArrBin[1], "001111"); // SUBI
		strcpy(opcArrBin[2], "001110"); // ADDCI
		strcpy(opcArrBin[3], "010000"); // NEGI
		strcpy(opcArrBin[4], "010001"); // ANDI
		strcpy(opcArrBin[5], "010011"); // XORI
		strcpy(opcArrBin[6], "010010"); // ORI
		strcpy(opcArrBin[7], "010100"); // MULTI
		strcpy(opcArrBin[8], "010101"); // LSLI
		strcpy(opcArrBin[9], "010110"); // LSRI
		strcpy(opcArrBin[10], "010111"); // RASI
		strcpy(opcArrBin[11], "011100"); // CMPI
		strcpy(opcArrBin[12], "011101"); // MOVI

		strcpy(opcArrBin[13], "000001"); // ADDR
		strcpy(opcArrBin[14], "000010"); // ADDC
		strcpy(opcArrBin[15], "000011"); // SUBR
		strcpy(opcArrBin[16], "000100"); // NEGR
		strcpy(opcArrBin[17], "000101"); // ANDR
		strcpy(opcArrBin[18], "000111"); // XORR
		strcpy(opcArrBin[19], "000110"); // ORR
		strcpy(opcArrBin[20], "001000"); // MULT
		strcpy(opcArrBin[21], "001001"); // LSLR
		strcpy(opcArrBin[22], "001010"); // LSRR
		strcpy(opcArrBin[23], "001011"); // RASR
		strcpy(opcArrBin[24], "011010"); // CMP
		strcpy(opcArrBin[25], "011011"); // MOV

		strcpy(opcArrBin[26], "100010"); // JMP
		strcpy(opcArrBin[27], "100101"); // JMPNQ
		strcpy(opcArrBin[28], "100100"); // JMPLE
		strcpy(opcArrBin[29], "100011"); // JMPEQ

		strcpy(opcArrBin[30], "000000"); // NOP 

		strcpy(opcArrBin[31], "011110"); // LOAD
		strcpy(opcArrBin[32], "011111"); // STORE
		strcpy(opcArrBin[33], "100000"); // POP
		strcpy(opcArrBin[34], "100001"); // PUSH

		strcpy(opcArrBin[35], "100110"); // HALT

		strcpy(opcArrBin[36], "100111"); // FIRCOR 
		strcpy(opcArrBin[37], "101000"); // FIRCOI
		strcpy(opcArrBin[38], "101010"); // FIRSAR
		strcpy(opcArrBin[39], "101011"); // FIRSARI
		strcpy(opcArrBin[40], "101001"); // FIRCORESET

		strcpy(opcArrBin[41], "101100"); // JMPR
		strcpy(opcArrBin[42], "101101"); // JMPNQR
		strcpy(opcArrBin[43], "101110"); // JMPLER
		strcpy(opcArrBin[44], "101111"); // JMPEQR
		strcpy(opcArrBin[45], "110000"); // JMPPA
		strcpy(opcArrBin[46], "110001"); // JMPPAR

		strcpy(opcArrBin[47], "110010"); // GETFLAG
		strcpy(opcArrBin[48], "110011"); // SETFLAG
		strcpy(opcArrBin[49], "110100"); // PUSHFLAGS
		strcpy(opcArrBin[50], "110101"); // POPFLAGS 
		strcpy(opcArrBin[51], "110110"); // POPFLAGS
#pragma endregion

		//Compares the temporary input array with an array of possible opcodes to find which one is present.
		//Since only one opcode is present per line, no position check is needed
		for (int i = 0; i < 100; i++) 
		{
			if (strstr(temp, opcArr[i]))
			{
				strcpy(output[outputIndex], opcArrBin[i]);
				outputIndex++;
				//sets the opcode type depending on what opcode is found in temp
				//opcodes are sorted by type in opcArr and opcArrBin

				if (i <= 12 || i == 37 || i == 39 || i == 48) 
				{
					opcType = IMMEDIATE; 
				}
				if (i > 12 && i <= 25)
				{
					opcType = REGISTER; 
				}
				if (i == 36 || i == 38 || i == 47 || i == 51)
				{
					opcType = REGISTER;
				}
				if (i > 25 && i <= 29)
				{
					opcType = JUMP; 
				}
				if (i >= 41 && i <= 46)
				{
					opcType = JUMP;
				}
				if (i >= 30 && i <= 35)
				{
					opcType = MEMORY; 
				}
				if (i == 39)
				{
					opcType = MEMORY;
				}
				if (i >= 49 && i <= 50)
				{
					opcType = MEMORY;
				}
				break;
			}
		}
#pragma endregion

#pragma region operandFinder 
		//Spaces finder - finds and saves the location of spaces in input. 
		//This is done to find the distance between spaces to find operands
		//This also allows the program to ignore multiple whitespaces for nicer assembly formatting
		int spaces[100]; //array to store the location of spaces in temp
		int spaceIndex = 0; //index where to save space position in spaces
		int spaceDist; //used to save the distance between

		memset(&spaces[0], 0, sizeof(spaces)); //resets the spaces array

		//finds and saves the location of all spaces and newlines since both serve the same purpose
		for (int i = 0; i < bufferSize; i++)
		{
			if (temp[i] == ' ' || temp[i] == '\n')
			{
				spaces[spaceIndex] = i;
				spaceIndex++;
			}
		}

		//Operand counter
		for (int i = 0; i < 100; i++)
		{
			if (spaces[i + 1] - spaces[i] > 1) //if spacedistance is more than 1 an operand is preset
			{
				opCount++;
			}
		}

#pragma region opArr
		//array that contains all register's names
		char opArr[32][10];
		strcpy(opArr[0], "$r0 ");
		strcpy(opArr[1], "$r1 ");
		strcpy(opArr[2], "$r2 ");
		strcpy(opArr[3], "$r3 ");
		strcpy(opArr[4], "$r4 ");
		strcpy(opArr[5], "$r5 ");
		strcpy(opArr[6], "$r6 ");
		strcpy(opArr[7], "$r7 ");
		strcpy(opArr[8], "$r8 ");
		strcpy(opArr[9], "$r9 ");
		strcpy(opArr[10], "$r10 ");
		strcpy(opArr[11], "$r11 ");
		strcpy(opArr[12], "$r12 ");
		strcpy(opArr[13], "$r13 ");
		strcpy(opArr[14], "$r14 ");
		strcpy(opArr[15], "$r15 ");
		strcpy(opArr[16], "$r16 ");
		strcpy(opArr[17], "$r17 ");
		strcpy(opArr[18], "$r18 ");
		strcpy(opArr[19], "$r19 ");
		strcpy(opArr[20], "$r20 ");
		strcpy(opArr[21], "$r21 ");
		strcpy(opArr[22], "$r22 ");
		strcpy(opArr[23], "$r23 ");
		strcpy(opArr[24], "$r24 ");
		strcpy(opArr[25], "$r25 ");
		strcpy(opArr[26], "$r26 ");
		strcpy(opArr[27], "$r27 ");
		strcpy(opArr[28], "$r28 ");
		strcpy(opArr[29], "$zero ");
		strcpy(opArr[30], "$sp ");
		strcpy(opArr[31], "$pc ");

#pragma endregion

#pragma region opArrBin
		// registers in binary
		char opArrBin[32][10];
		strcpy(opArrBin[0], "ERROR"); // DOES NOT WORK ON CPU BUT DOES EXIST (TECHNICALLY)
		strcpy(opArrBin[1], "00001"); // R1
		strcpy(opArrBin[2], "00010"); // R2
		strcpy(opArrBin[3], "00011"); // R3
		strcpy(opArrBin[4], "00100"); // R4
		strcpy(opArrBin[5], "00101"); // R5
		strcpy(opArrBin[6], "00110"); // R6
		strcpy(opArrBin[7], "00111"); // R7
		strcpy(opArrBin[8], "01000"); // R8
		strcpy(opArrBin[9], "01001"); // R9
		strcpy(opArrBin[10], "01010"); // R10
		strcpy(opArrBin[11], "01011"); // R11
		strcpy(opArrBin[12], "01100"); // R12
		strcpy(opArrBin[13], "01101"); // R13
		strcpy(opArrBin[14], "01110"); // R14
		strcpy(opArrBin[15], "01111"); // R15
		strcpy(opArrBin[16], "10000"); // R16
		strcpy(opArrBin[17], "10001"); // R17
		strcpy(opArrBin[18], "10010"); // R18
		strcpy(opArrBin[19], "10011"); // R19
		strcpy(opArrBin[20], "10100"); // R20
		strcpy(opArrBin[21], "10101"); // R21
		strcpy(opArrBin[22], "10110"); // R22
		strcpy(opArrBin[23], "10111"); // R23
		strcpy(opArrBin[24], "11000"); // R24
		strcpy(opArrBin[25], "11001"); // R25
		strcpy(opArrBin[26], "11010"); // R26
		strcpy(opArrBin[27], "11011"); // R27
		strcpy(opArrBin[28], "11100"); // R28
		strcpy(opArrBin[29], "11101"); // ZERO
		strcpy(opArrBin[30], "11110"); // SP
		strcpy(opArrBin[31], "11111"); // PC
#pragma endregion
		
		if (opcType == IMMEDIATE) //immediate opcode type
		{
			for (int i = 0; i < opCount; i++)
			{
					spaceDist = spaces[i + 1] - spaces[i];
					if (spaceDist > 1) //if spacedistance is greater than one, an operand must be present
					{
						char opTemp[100]; //temporary array for storing one operand at a time

						for (int j = 0; j < spaceDist; j++) //saves operand from the current space location +1 to the next space location -1
						{
							opTemp[j] = temp[spaces[i] + 1 + j];
						}
						opTemp[spaceDist] = '\0';

						//checks what kind of operand is present in the current opTemp
						if (strstr(opTemp, "$")) //register operand
						{
							for (int u = 0; u < 100; u++)
							{
								if (strstr(opTemp, opArr[u])) //checks which register is contianed in opTemp
								{
									strcpy(output[outputIndex], opArrBin[u]); //saves the binary of the contianed register in output
									outputIndex++;
									break;
								}
							}
						}
						else if (strstr(opTemp, "#")) //label immediate. Allows for manipulation of labels in immediate opcodes
						{
							for (int i = 0; i < 100; i++)
							{
								opTemp[i] = opTemp[i + 1]; //shifts the optemp one space to the left since it begins with a space
														   //since the labelname array does not.

								if (opTemp[i] == '\0') //string terminator char
								{
									opTemp[i - 1] = '\0'; //ends the optemp string and stops the shift
									break;
								}

							}

							for (int i = 0; i < 100; i++) //compares the optemp with the labelnames to find out which one is to be printed
							{
								if (strstr(labelName[i], opTemp)) //if labelname[i] contains optemp
								{
									int num = labelLine[i]; //saves the labelline to an int
									char padString[17]; //creates a temporary string which is needed to pad the value to 16 bits,
														//after it is converted to binary
									int zeros = 0; //int for storing the amount of padding zeros

									_itoa(num, padString, 2); //saves num as a string in padstring in radix 2 (binary)

									//checks for the end of padstring and uses this location to find out how many padding zeros are needed.
									//Afterwards it creates a temporary char array since the padding has to be done from the right,
									//the binary value is then appended onto the temporary string which creates a 16 bit string
									//the temporary string is then saved in the original one and saved for output
									for (int j = 0; j < 17; j++)
									{
										if (padString[j] == '\0')
										{
											zeros = 16 - j;
											char padTemp[17];
											for (int u = 0; u < zeros; u++)
											{
												padTemp[u] = '0';
											}
											padTemp[zeros] = '\0';

											strcat(padTemp, padString);
											strcpy(padString, padTemp);
										}

									}
									strcpy(output[outputIndex], padString);
									outputIndex++;
									break;
								}
							}
						}

						else // if previous statements were not true, the immediate value is present
						{
							//same immediate handling as previously
							int num = atoi(opTemp);

							if (num >= 0) //positive
							{
								int zeros = 0;
								char padString[17];
								_itoa(num, padString, 2);
								for (int j = 0; j < 17; j++)
								{
									if (padString[j] == '\0')
									{
										zeros = 16 - j;
										char padTemp[17];
										for (int u = 0; u < zeros; u++)
										{
											padTemp[u] = '0';
										}
										padTemp[zeros] = '\0';

										strcat(padTemp, padString);
										strcpy(output[outputIndex], padTemp);
										outputIndex++;
										break;
									}
								}
							}
							else //negative
							{
								char padString[33]; //32 bit string since program is 32 bit and negative numbers are converted to that
								_itoa(num, padString, 2);
								char padTemp[17];
								for (int u = 16; u < 33; u++)
								{
									padTemp[u - 16] = padString[u];
								}
								strcpy(output[outputIndex], padTemp);
								outputIndex++;
							}
						}
					}
				}
			}
		
		if (opcType == REGISTER) 
		{
			for (int i = 0; i < opCount + 1; i++)
			{
				spaceDist = spaces[i + 1] - spaces[i];
				if (spaceDist > 1) //operand is present
				{
					//reads operand into temp array
					char opTemp[100];
					for (int j = 0; j < spaceDist; j++)
					{
						opTemp[j] = temp[spaces[i] + 1 + j]; //checks from one position to the right of a space and for space distance -1
					}
					//compares operand with register array and prints found register as binary
					for (int u = 0; u < 100; u++)
					{
						if (strstr(opTemp, opArr[u]))
						{
							strcpy(output[outputIndex], opArrBin[u]);
							outputIndex++;
							break;
						}
					}
				}
			}
		}

		if (opcType == MEMORY)
		{
			for (int i = 0; i < opCount; i++)
			{
				spaceDist = spaces[i + 1] - spaces[i];
				if (spaceDist > 1) //operand must be present
				{
					//reads operand into temp array
					char opTemp[100];
					for (int j = 0; j < spaceDist; j++)
					{
						opTemp[j] = temp[spaces[i] + 1 + j]; //checks from one position to the right of a space and for space distance -1
					}
				
					if (i == 1) //if i=1 the operand containing the memory address is present since its written OPC REG [MEM]
					{
						//Checks for and saves the location of the + for [REG+IMM] 
						if (strstr(opTemp,"+"))
						{
							immMem = 1; //sets the immediate memory for correct output
							int plusLoc = 0;
							char regTemp[10]; //temp array to store the register part of the operand
							for (int j = 0; j < 100; j++)//plusfinder
							{
								if (opTemp[j] == '+')
								{
									plusLoc = j; //saves the location of the plus which splits the REG and IMM
									break;
								}
							}
							//loads the registry into regtemp to compare it to opArr
							for (int j = 0; j < plusLoc; j++)
							{
								if (j == plusLoc - 1)
								{
									regTemp[j] = '\0'; //ends the string so string functions can be used
								}
								else
								{
									regTemp[j] = opTemp[j + 1];
								}
								
							}
							strcat(regTemp, " "); //appens a space on the end of regtemp to allow it to compare to opArr properly
							
							for (int u = 0; u < 100; u++)
							{
								if (strstr(regTemp, opArr[u]))
								{
									strcpy(output[outputIndex], opArrBin[u]); //copies found registry to output in binary
									outputIndex++;
									break;
								}
							}
							

							//loads the immediate part of the operand into a temporary array and outputs it as binary the same as the other immedates
							char immTemp[10];
							for (int j = plusLoc; j < 100; j++)
							{
								if (opTemp[j + 1] != ']')
								{
									immTemp[j - plusLoc] = opTemp[j + 1];
								}
								else
								{
									immTemp[j - plusLoc] = '\0';
									break;
								}
							}
							//converts the immediate value into binary and saves it to output
							int num = atoi(immTemp);
							char padString[17];
							int zeroes = 0;
							_itoa(num, padString, 2);
							for (int j = 0; j < 17; j++)
							{
								if (padString[j] == '\0')
								{
									zeroes = 16 - j;
									char padTemp[17];
									for (int u = 0; u < zeroes; u++)
									{
										padTemp[u] = '0';
									}
									padTemp[zeroes] = '\0';

									strcat(padTemp, padString);
									strcpy(padString, padTemp);
								}
							}
							strcpy(output[outputIndex], padString);
							outputIndex++;
						}
						//if no [REG+IMM] is given, and $ is present, it must be [REG] and is treated as normal register operand
						//except the "[]" has to be ignored
						else if(strstr(opTemp,"$"))
						{
							immMem = 0; //sets the immMem to register only for correct output
							char regTemp[20];
							for (int j = 0; j < 20; j++)
							{
								if (opTemp[j + 1] != ']')
								{
									regTemp[j] = opTemp[j + 1];
								}
								else
								{
									regTemp[j] = '\0';
									strcat(regTemp, " ");
									break;
								}
							}
							//compares regtemp with opArr and saves the correct registry in binary to output
							for (int u = 0; u < 100; u++)
							{
								if (strstr(regTemp, opArr[u]))
								{
									strcpy(output[outputIndex], opArrBin[u]);
									outputIndex++;
									break;
								}
							}
						}
						else //neither [REG+IMM] nor [REG] so it must be [IMM]
						{
							immMem = 2; //sets immMem for correct output
							//loads the immediate value into a temp array and converts it to binary for output like other immediates
							char immTemp[10]; 
							for (int j = 1; j < 100; j++)
							{
								if (opTemp[j] != ']')
								{
									immTemp[j-1] = opTemp[j];
								}
								else
								{
									immTemp[j - 1] = '\0';
									break;
								}
							}
							int num = atoi(immTemp);
							char padString[17];
							int zeroes = 0;
							_itoa(num, padString, 2);
							for (int j = 0; j < 17; j++)
							{
								if (padString[j] == '\0')
								{
									zeroes = 16 - j;
									char padTemp[17];
									for (int u = 0; u < zeroes; u++)
									{
										padTemp[u] = '0';
									}
									padTemp[zeroes] = '\0';

									strcat(padTemp, padString);
									strcpy(padString, padTemp);
									break;
								}

							}
							strcpy(output[outputIndex], padString);
							outputIndex++;
							//Exception for this immediate handling is that it has to output register 29 as [REG+IMM],
							// since register 29 is a zero register which becomes [0+IMM]
							strcpy(output[outputIndex], opArrBin[29]); //zero reg
							outputIndex++;
						}

					}
					else //outputs the REG part of the opcode. Same as earlier register output
					{
						for (int u = 0; u < 100; u++)
						{
							if (strstr(opTemp, opArr[u]))
							{
								strcpy(output[outputIndex], opArrBin[u]);
								outputIndex++;
								break;
							}
						}
					}
				}
			}
		}

		if (opcType == JUMP)
		{
			for (int i = 0; i < opCount + 1; i++)
			{
				spaceDist = spaces[i + 1] - spaces[i];
				if (spaceDist > 1) //if spacedist > 1 an operand must be present
				{
					//reads operand into temp array
					char opTemp[100];
					for (int j = 0; j < spaceDist; j++)
					{
						opTemp[j] = temp[spaces[i] + 1 + j]; //checks from one position to the right of a space and for space distance -1
						if (j == spaceDist - 1)
						{
							opTemp[j + 1] = '\0';
						}
					}
					if (strstr(opTemp, "#")) //label
					{
						//compares the found operand with the known labelnames to see which is called.
						//when the correct labelname is found, the corresponding labeline is saved to output
						//as binary, the same as other immediates are handled
						regJump = 0; //no reg in jump
						for (int u = 0; u < 100; u++)
						{
							if (strstr(opTemp, labelName[u]))
							{
								char padString[17];
								_itoa(labelLine[u], padString, 2);
								int zeros = 0;
								for (int j = 0; j < 17; j++)
								{
									if (padString[j] == '\0')
									{
										zeros = 16 - j;
										char padTemp[17];
										for (int u = 0; u < zeros; u++)
										{
											padTemp[u] = '0';
										}
										padTemp[zeros] = '\0';

										strcat(padTemp, padString);
										strcpy(padString, padTemp);
									}
								}

								strcpy(output[outputIndex], padString);
								outputIndex++;
								break;
							}
						}
					}
					else if (strstr(opTemp,"$")) //reg
					{
						//compares operand with register array and prints found register as binary
						regJump = 1; //reg in jump
						for (int u = 0; u < 100; u++)
						{
							if (strstr(opTemp, opArr[u]))
							{
								strcpy(output[outputIndex], opArrBin[u]);
								outputIndex++;
								break;
							}
						}
					}
				}				
			}
		}
		
#pragma endregion

#pragma region output
		//outputs the saved output arrays in the required format for each opcode type
		//in total there has to be 32 bits which requires some to be padded with zeros
		//outputs to both the output file, as well as the console window for easier debugging
		if (strstr(output[0], opcArrBin[12])) //Type MOVE immediate
		{
			printf("%s %s %s %s", output[0], output[5], output[2], output[1]);
			fprintf(fpOut, "%s%s%s%s", output[0], output[5], output[2], output[1]);
		}

		if (strstr(output[0], opcArrBin[11])) //Type CMP immediate
		{
			printf("%s %s %s %s", output[0], output[1], output[5], output[2]);
			fprintf(fpOut, "%s%s%s%s", output[0], output[1], output[5], output[2]);
		}

		if (strstr(output[0], opcArrBin[25])) //Type MOVE Registers
		{
			printf("%s %s %s %s %s %s", output[0], output[1], output[2], output[5], output[5], output[6]);
			fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[1], output[2], output[5], output[5], output[6]);
		}

		if (strstr(output[0], opcArrBin[24])) //Type CMP Registers
		{
			printf("%s %s %s %s %s %s", output[0], output[1], output[5], output[2], output[5], output[6]);
			fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[1], output[5], output[2], output[5], output[6]);
		}

		if (strstr(output[0], opcArrBin[30]))//NOP
		{
			printf("%s %s %s %s %s %s", output[0], output[5], output[5], output[5], output[5], output[6]);
			fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[5], output[5], output[5], output[5], output[6]);
		}

		for (int q = 0; q < 11; q++)
		{
			if (q == 3)
			{
				q++;
			}
			if (strstr(output[0], opcArrBin[q])) //Type Immediates
			{
				printf("%s %s %s %s", output[0], output[1], output[3], output[2]);
				fprintf(fpOut, "%s%s%s%s", output[0], output[1], output[3], output[2]);
			}
		}

		if (strstr(output[0],opcArrBin[16]))//NEGR
		{
			printf("%s %s %s %s %s %s", output[0], output[1], output[2], output[5], output[5], output[6]);
			fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[1], output[2], output[5], output[5], output[6]);
		}

		for (int q = 13; q < 24; q++)
		{
			if (q == 16)
			{
				q++;
			}
			if (strstr(output[0], opcArrBin[q])) //Type Registers
			{
				printf("%s %s %s %s %s %s", output[0], output[1], output[3], output[2], output[5], output[6]);
				fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[1], output[3], output[2], output[5], output[6]);
			}
		}
		
		if (strstr(output[0], opcArrBin[3]))//NEGI
		{
			printf("%s %s %s %s", output[0], output[5], output[2], output[1]);
			fprintf(fpOut, "%s%s%s%s", output[0], output[5], output[2], output[1]);
		}

		if (opcType == JUMP)
		{
			if (regJump == 0)//label
			{
				printf("%s %s %s %s", output[0], output[5], output[5], output[1]);
				fprintf(fpOut, "%s%s%s%s", output[0], output[5], output[5], output[1]);
			}
			else if (regJump == 1) //reg
			{
				printf("%s %s %s %s %s %s", output[0], output[1], output[5], output[5], output[5], output[6]);
				fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[1], output[5], output[5], output[5], output[6]);
			}
		}
		if (strstr(output[0], opcArrBin[31]))//LOAD
		{
			if (immMem == 1)// reg+imm
			{
				printf("%s %s %s %s", output[0], output[2], output[1], output[3]);
				fprintf(fpOut, "%s%s%s%s", output[0], output[2], output[1], output[3]);
			}
			else if (immMem == 2) //imm
			{
				printf("%s %s %s %s", output[0], output[3], output[1], output[2]);
				fprintf(fpOut, "%s%s%s%s", output[0], output[3], output[1], output[2]);
			}
			else //reg
			{
				printf("%s %s %s %s %s %s", output[0], output[2], output[1], output[5], output[5], output[6]);
				fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[2], output[1], output[5], output[5], output[6]);
			}
		}
		if (strstr(output[0], opcArrBin[32]))//STORE
		{
			if (immMem == 1)// reg+imm
			{
				printf("%s %s %s %s", output[0], output[2], output[1], output[3]);
				fprintf(fpOut, "%s%s%s%s", output[0], output[2], output[1], output[3]);
			}
			else if (immMem == 2) //imm
			{
				printf("%s %s %s %s", output[0], output[3], output[1], output[2]);
				fprintf(fpOut, "%s%s%s%s", output[0], output[3], output[1], output[2]);
			}
			else //reg
			{
				printf("%s %s %s %s %s %s", output[0], output[2], output[1], output[5], output[5], output[6]);
				fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[2], output[1], output[5], output[5], output[6]);
			}
		}
		
			if (strstr(output[0], opcArrBin[33])) // POP
			{
				printf("%s %s %s %s %s %s", output[0], output[5], output[1], output[5], output[5], output[6]);
				fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[5], output[1], output[5], output[5], output[6]);
			}
			if (strstr(output[0], opcArrBin[34])) // Push
			{
				printf("%s %s %s %s %s %s", output[0], output[5], output[5], output[1], output[5], output[6]);
				fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[5], output[5], output[1], output[5], output[6]);
			}
		if (strstr(output[0],opcArrBin[35]))//Halt
		{
			printf("%s %s %s %s %s %s", output[0], output[5], output[5], output[5], output[5], output[6]);
			fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[5], output[5], output[5], output[5], output[6]);
		}
		if (strstr(output[0], opcArrBin[36])) //FIRCOR
		{
			printf("%s %s %s %s %s %s", output[0], output[1], output[5], output[5], output[5], output[6]);
			fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[1], output[5], output[5], output[5], output[6]);
		}
		if (strstr(output[0], opcArrBin[37])) //FIRCORI
		{
			printf("%s %s %s %s", output[0], output[5], output[5], output[1]);
			fprintf(fpOut, "%s%s%s%s", output[0], output[5], output[5], output[1]);
		}
		if (strstr(output[0], opcArrBin[38])) //FIRSAR
		{
			printf("%s %s %s %s %s %s", output[0], output[1], output[2], output[5], output[5], output[6]);
			fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[1], output[2], output[5], output[5], output[6]);
		}
		if (strstr(output[0], opcArrBin[39])) //FIRSAI
		{
			printf("%s %s %s %s", output[0], output[5], output[2], output[1]);
			fprintf(fpOut, "%s%s%s%s", output[0], output[5], output[2], output[1]);
		}
		if (strstr(output[0], opcArrBin[40]))//NOP
		{
			printf("%s %s %s %s %s %s", output[0], output[5], output[5], output[5], output[5], output[6]);
			fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[5], output[5], output[5], output[5], output[6]);
		}
		if (strstr(output[0], opcArrBin[47])) //GETFLAG
		{
			printf("%s %s %s %s %s %s", output[0], output[5], output[1], output[5], output[5], output[6]);
			fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[5], output[1], output[5], output[5], output[6]);
		}
		if (strstr(output[0], opcArrBin[48])) //SETFLAG
		{
			printf("%s %s %s %s", output[0], output[5], output[5], output[1]);
			fprintf(fpOut, "%s%s%s%s", output[0], output[5], output[5], output[1]);
		}
		if (strstr(output[0], opcArrBin[49]) || strstr(output[0], opcArrBin[50]))//PUSHFLAGS/POPFLAGS
		{
			printf("%s %s %s %s %s %s", output[0], output[5], output[5], output[5], output[5], output[6]);
			fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[5], output[5], output[5], output[5], output[6]);
		}
		if (strstr(output[0], opcArrBin[51])) //SETFLAGR
		{
			printf("%s %s %s %s %s %s", output[0], output[1], output[5], output[5], output[5], output[6]);
			fprintf(fpOut, "%s%s%s%s%s%s", output[0], output[1], output[5], output[5], output[5], output[6]);
		}
#pragma endregion

#pragma region MIF endLinePrint
		//resets the output variables before next line is read and converted
		outputIndex = 0;
		memset(output, 0, sizeof(output));
		
		//newline to make sure each output is on seperate lines - mostly for neatness and easier debugging
		printf("\n");

		//if no label is present and the opcType is not 0 (which indicates blank line or comment)
		//the required line endings is printed to the output file.
		//these are required for .mif format
		if (label == false && opcType != 0)
		{
			fprintf(fpOut, ";");
			fprintf(fpOut, "\n");
			lineCount++;
		}
#pragma endregion
		
	}

	//after the final line is read, the .mif format requires the remaining memory addresses to be populated by zeros
	//followed by an "END;"
	fprintf(fpOut, "[%d..%d] : 00000000000000000000000000000000;", lineCount, memoryDepth - 1);
	fprintf(fpOut, "\nEND;\n");
	
	//both files are closed
	fclose(fpIn);
	fclose(fpOut);

	//console prints success
	printf("Assembly successful. Press enter to exit...");
	//enter to exit
	getchar();
	return 0;
}