    /* ========================================
 *
 * Copyright YOUR COMPANY, THE YEAR
 * All Rights Reserved
 * UNPUBLISHED, LICENSED SOFTWARE.
 *
 * CONFIDENTIAL AND PROPRIETARY INFORMATION
 * WHICH IS THE PROPERTY OF your company.
 *
 * ========================================
*/
/* Project library includes */
#include "project.h"
#include <DMA_DelSig_dma.h>
#include <DMA_I2S_dma.h>
#include <DMA_SAR_dma.h>
//#include <DMA_SPISlave_dma.h>
#include <ADC_DelSig.h>
#include <SPI_Slave.h>

/* Project Defines */
#define FALSE  0 /* Boolean definitions for integers, added to make the code more readable */
#define TRUE   1
#define DMA_flag 1 /* When this flag is high (1) DMA is enabled and while it is low (0) DMA is disabled */
#define BUFFER_SIZE 16 /* Buffer size of the SPI */
#define STORE_TD_CFG_ONCMPLT 1

void DMA_DelSig_Config(void);
void DMA_I2S_Config(void);
void DMA_SAR_Config(void);
void DMA_SPIS_RX_Config(void);
void DMA_SPIS_TX_Config(void);

/* Variable declarations for DMA_DelSig */
uint8 DMA_DelSig_Chan;
uint8 DMA_DelSig_TD[2];
/* Variable declarations for DMA_I2S */
uint8 DMA_I2S_Chan;
uint8 DMA_I2S_TD[4];
/* Variable declarations for DMA_SAR */
uint8 DMA_SAR_Chan;
uint8 DMA_SAR_TD [2];
/* Variable declarations for the DMA_SPIS_Rx */
uint8 rxChannel;
uint8 rxTD;
uint16 rxBuffer [BUFFER_SIZE];

/* Variable declarations for the DMA_SPIS_Tx */
uint8 txChannel;
uint8 txTD[4];
uint16 txBuffer [BUFFER_SIZE-1];

/* Declaration of a 16-bit union */
union buffer
{
    uint16 in; /* Input of the union */
    uint8 out[2]; /* Output of the union */
};
union buffer buf; /* Instancing a union-buffer which is used when DMA is disabled */
union buffer I2Sbuffer0, I2Sbuffer1; /* Instancing two union buffers which is for I2S used when DMA is enabled */
union buffer TXbuffer0, TXbuffer1;

/* This function shuts off all the LEDs */
void LED_ShutOff()
{
    LED1_Write( FALSE );
    LED2_Write( FALSE );
    LED3_Write( FALSE );
    LED4_Write( FALSE );
    LED5_Write( FALSE );
    LED6_Write( FALSE );
    LED7_Write( FALSE );
    LED8_Write( FALSE );
}
/* This function turns on a select number of LEDs depending on the input number */
/* The order at which the LEDs are turned on is predetermined */
void LED_On(uint8 n)
{
    switch(n)
    {
        case 1:
            LED1_Write( TRUE );
            LED2_Write( FALSE );
            LED3_Write( FALSE );
            LED4_Write( FALSE );
            LED5_Write( FALSE );
            LED6_Write( FALSE );
            LED7_Write( FALSE );
            LED8_Write( FALSE );
            break;
        case 2:
            LED1_Write( TRUE );
            LED2_Write( TRUE );
            LED3_Write( FALSE );
            LED4_Write( FALSE );
            LED5_Write( FALSE );
            LED6_Write( FALSE );
            LED7_Write( FALSE );
            LED8_Write( FALSE );
            break;
        case 3:
            LED1_Write( TRUE );
            LED2_Write( TRUE );
            LED3_Write( TRUE );
            LED4_Write( FALSE );
            LED5_Write( FALSE );
            LED6_Write( FALSE );
            LED7_Write( FALSE );
            LED8_Write( FALSE );
            break;
        case 4:
            LED1_Write( TRUE );
            LED2_Write( TRUE );
            LED3_Write( TRUE );
            LED4_Write( TRUE );
            LED5_Write( FALSE );
            LED6_Write( FALSE );
            LED7_Write( FALSE );
            LED8_Write( FALSE );
            break;
        case 5:
            LED1_Write( TRUE );
            LED2_Write( TRUE );
            LED3_Write( TRUE );
            LED4_Write( TRUE );
            LED5_Write( TRUE );
            LED6_Write( FALSE );
            LED7_Write( FALSE );
            LED8_Write( FALSE );
            break;
        case 6:
            LED1_Write( TRUE );
            LED2_Write( TRUE );
            LED3_Write( TRUE );
            LED4_Write( TRUE );
            LED5_Write( TRUE );
            LED6_Write( TRUE );
            LED7_Write( FALSE );
            LED8_Write( FALSE );
            break;
        case 7:
            LED1_Write( TRUE );
            LED2_Write( TRUE );
            LED3_Write( TRUE );
            LED4_Write( TRUE );
            LED5_Write( TRUE );
            LED6_Write( TRUE );
            LED7_Write( TRUE );
            LED8_Write( FALSE );
            break;
        case 8:
            LED1_Write( TRUE );
            LED2_Write( TRUE );
            LED3_Write( TRUE );
            LED4_Write( TRUE );
            LED5_Write( TRUE );
            LED6_Write( TRUE );
            LED7_Write( TRUE );
            LED8_Write( TRUE );
            break;
        default:
            LED_ShutOff();
            break;
    }
}

char lastInputString[16];
/* This is a function which simplifies writing on the LCD into a single line of code, the inputs are:
 * rowSelect selects which row of the LCD is selected, zero is the first row and one is the second row
 * columnSelect selects which column of the LCD is used for the first character of the input string
 * zero is the first column, one is the second column, etc.
 * printString is the input string, this is a 16 byte character array.
 */
void LCD_WriteLine(uint8 rowSelect, uint8 columnSelect, char printString[16])
{
    if(printString != lastInputString) /* Checks if the function call has the same input string as the previous function call, i.e. if it's from a loop. */
    {
        LCD_Position(0,0); /* Sets the position to the first row and first column */
        LCD_PrintString("                "); /* Clears the entire row of characters */
        LCD_Position(1,0); /* Sets the position to the second row and the first column */
        LCD_PrintString("                "); /* Clears the entire row of characters */
        LCD_Position(rowSelect,columnSelect); /* Selects the input row and column */
        LCD_PrintString(printString); /* Writes the input string on the LCD */
        
        for (uint8 i = 0; i < 15; i++) /* For-loop which runs between zero and 15, which are the 16 input values of the character arrays*/
        {
             lastInputString[i] = printString[i]; /* Copies the input string into a global variable which is stored for the next use of this functon */
        }
    }
}
uint16 avgerage(uint16 arr[],uint16 size){
    uint32 total=0;
    
    for (uint32_t i = 0; i < size; i++){
         total+=arr[i];
    }
    uint16 result=total/size;
    return (uint16) result;
    
}
    
uint8 ADC_SAR_Flag = 0u; /* Flag condition which is activated once the ADC_SAR has reached its EOC */
uint16 ADC_SAR_Output; /* Variable to store ADC SAR result */
#define BUFFSIZE 100
uint16 ringbuff[BUFFSIZE]={0};
uint8 rp=0;
uint16 updateBuffer(uint16 new){
    ringbuff[rp]=new;
    rp=rp<BUFFSIZE?rp+1:0;
    return avgerage(ringbuff,BUFFSIZE);  
};
uint16 ADC_SAR_ReadValue;
/* Interrupt Service Routine (ISR) for the ADC_SAR internal EOC Interrupt */
CY_ISR(ADC_SAR_ISR_LOC)
{
    ADC_SAR_ReadValue = ADC_SAR_CountsTo_mVolts(ADC_SAR_GetResult16()); /* Reads a 12-bit sample on the ADC_SAR and stores it in the variable */
    ADC_SAR_Flag = 1u; /* Sets the flag high */
}
uint8 flag = 1u;
uint8 whileVariable = 0u;
int main(void)
{
    CyGlobalIntEnable; /* Enable global interrupts. */

    /* Initializes the three DMA configurations */
    DMA_SAR_Config();
    DMA_SPIS_RX_Config();
	DMA_SPIS_TX_Config();
    
    SPI_Slave_Start(); /* Initializes the SPI Slave */
    SPI_Slave_WriteTxDataZero(0x00); /* Writes zero to the hardware register of the SPI_Slave */
    
    CyDmaChEnable(rxChannel, STORE_TD_CFG_ONCMPLT); /* Enables the DMA channel of DMA_SPIS_RX */
    CyDmaChEnable(txChannel, STORE_TD_CFG_ONCMPLT); /* Enables the DMA channel of DMA_SPIS_TX */

    /* If DMA is selected for the I2S part of the program, then this code block initializes the two DMA configurations */
	#if DMA_flag 
    DMA_DelSig_Config();
	DMA_I2S_Config();
	#endif
    
    I2S_1_Start(); /* Initializes the I2S */
    
    ADC_DelSig_Start(); /* Initializes the ADC */
    ADC_DelSig_StartConvert(); /* Starts the ADC conversion of the ADC_DelSig */
	
    ADC_SAR_Start(); /* Initializes the ADC */
    ADC_SAR_IRQ_StartEx(ADC_SAR_ISR_LOC); /* Initializes the internal End of Conversion (EOC) Interrupt of the ADC_SAR */
    ADC_SAR_StartConvert(); /* Starts the ADC conversion of the ADC_SAR */
    
    
    LCD_Start();
    LCD_WriteLine(0,0,"PSoC LP5");
    LCD_WriteLine(1,0,"Setup complete");
    
    I2S_1_EnableTx(); /* Enables the I2S transmitter */
    for(;;)
    {
        ADC_SAR_Output = updateBuffer(ADC_SAR_ReadValue);
        //LCD_WriteLine(0,0," ");
        LCD_Position(0,0);
        LCD_PrintNumber(ADC_SAR_Output);
        LCD_PrintString("    ");
        //yDelay(100);
		/* This code block contains the data transfer between ADC and I2S without using DMA */
        #if !DMA_flag
		//uint8 whileVariable = 0u; /* flag condition for the while-loop */
		//uint8 flag = 1u; /* Flag condition deciding which decides which I2S channel is used */
		while(whileVariable == 0u) /* Starts a while-loop which runs until data has been written to both I2S channel */
		{
			if(I2S_1_ReadTxStatus(CH0)&I2S_1_TX_FIFO_0_NOT_FULL) /* Checks if the I2S TX FIFO buffer is not full, i.e. if I2S is ready to send data */
			{
				if(flag == 1) /* Checks if the loop is ready to send data on the first channel */
				{
					flag = 0; /* Changes the condition, so the first channel is the next one which will be written to */
					buf.in = ADC_DelSig_GetResult16(); /* Reads the ADC result as a 16-bit number and stores it in a union-buffer */
					I2S_1_WriteByte(buf.out[flag], 0); /* Writes the first 8-bits of the union-buffer to the I2S TX FIFO buffer */
				}
				else /* flag == 0 */
				{
					flag = 1; /* Changes the condition, so the second channel is the next one which will be written to */
					I2S_1_WriteByte(buf.out[flag], 0); /* Writes the second 8-bits of the union-buffer to the I2S TX FIFO buffer */
					whileVariable = 1; /* Changes the while-loop condition so the while-loop is complete */
				}
			}
		}
        #endif
		
        //if(ADC_SAR_Flag != 0u)
        {
            if(ADC_SAR_IsEndConversion(ADC_SAR_RETURN_STATUS))
            {
                //ADC_SAR_Output = ADC_SAR_CountsTo_mVolts(ADC_SAR_GetResult16());                
                if(ADC_SAR_Output >= 0 && ADC_SAR_Output < 100)
                {
                    LED_On(1);
                }
                else if (ADC_SAR_Output >= 101 && ADC_SAR_Output < 1400)
                {
                    LED_On(2);
                }
                else if (ADC_SAR_Output >= 1401 && ADC_SAR_Output < 2400)
                {
                    LED_On(3);
                }
                else if (ADC_SAR_Output >= 2401 && ADC_SAR_Output < 3500)
                {
                    LED_On(4);
                }
                else if (ADC_SAR_Output >= 3501 && ADC_SAR_Output < 4000)
                {
                    LED_On(5);
                }
                else if (ADC_SAR_Output >= 4001 && ADC_SAR_Output < 4300)
                {
                    LED_On(6);
                }
                else if (ADC_SAR_Output >= 4301 && ADC_SAR_Output < 4500)
                {
                    LED_On(7);
                }
                else if (ADC_SAR_Output >= 4501 && ADC_SAR_Output < 4800)
                {
                    LED_On(8);
                }
                else
                {
                    // Do nothing
                    LED_ShutOff();
                }
            }
            //ADC_SAR_Flag = 0u;
        }
    }
}

void DMA_DelSig_Config(void)
{
	/* Defines for DMA_DelSig */
	#define DMA_DelSig_BYTES_PER_BURST 2
	#define DMA_DelSig_REQUEST_PER_BURST 1
	#define DMA_DelSig_SRC_BASE (CYDEV_PERIPH_BASE)
	#define DMA_DelSig_DST_BASE (CYDEV_SRAM_BASE)

	/* DMA_DelSig Configuration */
	DMA_DelSig_Chan = DMA_DelSig_DmaInitialize(DMA_DelSig_BYTES_PER_BURST, DMA_DelSig_REQUEST_PER_BURST, 
								 HI16(DMA_DelSig_SRC_BASE), HI16(DMA_DelSig_DST_BASE));
	/* Transaction Descriptor (TD) allocation */
	DMA_DelSig_TD[0] = CyDmaTdAllocate();
	DMA_DelSig_TD[1] = CyDmaTdAllocate();
	
	/* TD configuration settings */
	CyDmaTdSetConfiguration(DMA_DelSig_TD[0], 2, DMA_DelSig_TD[1], CY_DMA_TD_INC_DST_ADR);
	CyDmaTdSetConfiguration(DMA_DelSig_TD[1], 2, DMA_DelSig_TD[0], CY_DMA_TD_INC_DST_ADR);
	
	/* Set Source and Destination address of each TD */
	CyDmaTdSetAddress(DMA_DelSig_TD[0], LO16((uint32)ADC_DelSig_DEC_SAMP_PTR), LO16((uint32)&I2Sbuffer0.in));
	CyDmaTdSetAddress(DMA_DelSig_TD[1], LO16((uint32)ADC_DelSig_DEC_SAMP_PTR), LO16((uint32)&I2Sbuffer1.in));
	
	/* TD initialization */
	CyDmaChSetInitialTd(DMA_DelSig_Chan, DMA_DelSig_TD[0]);
	
	/* Enable the DMA channel */
	CyDmaChEnable(DMA_DelSig_Chan, 1);
}

void DMA_I2S_Config(void)
{
	/* Defines for DMA_I2S */
	#define DMA_I2S_BYTES_PER_BURST 1
	#define DMA_I2S_REQUEST_PER_BURST 1
	#define DMA_I2S_SRC_BASE (CYDEV_SRAM_BASE)
	#define DMA_I2S_DST_BASE (CYDEV_PERIPH_BASE)

	/* DMA_I2S Channel configuration */
	DMA_I2S_Chan = DMA_I2S_DmaInitialize(DMA_I2S_BYTES_PER_BURST, DMA_I2S_REQUEST_PER_BURST, 
									 HI16(DMA_I2S_SRC_BASE), HI16(DMA_I2S_DST_BASE));
	
	/* (TD) allocation */
	DMA_I2S_TD[0] = CyDmaTdAllocate();
	DMA_I2S_TD[1] = CyDmaTdAllocate();
	DMA_I2S_TD[2] = CyDmaTdAllocate();
	DMA_I2S_TD[3] = CyDmaTdAllocate();
	
	/* TD configuration settings */
	CyDmaTdSetConfiguration(DMA_I2S_TD[0], 1, DMA_I2S_TD[1], CY_DMA_TD_INC_SRC_ADR);
	CyDmaTdSetConfiguration(DMA_I2S_TD[1], 1, DMA_I2S_TD[2], CY_DMA_TD_INC_SRC_ADR);
	CyDmaTdSetConfiguration(DMA_I2S_TD[2], 1, DMA_I2S_TD[3], CY_DMA_TD_INC_SRC_ADR);
	CyDmaTdSetConfiguration(DMA_I2S_TD[3], 1, DMA_I2S_TD[0], CY_DMA_TD_INC_SRC_ADR);
	
	/* Set Source and Destination address of each TD */
	CyDmaTdSetAddress(DMA_I2S_TD[0], LO16((uint32)&I2Sbuffer0.out[1]), LO16((uint32)I2S_1_TX_CH0_F0_PTR));
	CyDmaTdSetAddress(DMA_I2S_TD[1], LO16((uint32)&I2Sbuffer0.out[0]), LO16((uint32)I2S_1_TX_CH0_F0_PTR));
	CyDmaTdSetAddress(DMA_I2S_TD[2], LO16((uint32)&I2Sbuffer1.out[1]), LO16((uint32)I2S_1_TX_CH0_F0_PTR));
	CyDmaTdSetAddress(DMA_I2S_TD[3], LO16((uint32)&I2Sbuffer1.out[0]), LO16((uint32)I2S_1_TX_CH0_F0_PTR));
	
	/* TD initialization */
	CyDmaChSetInitialTd(DMA_I2S_Chan, DMA_I2S_TD[0]);
	
	/* Enable the DMA channel */
	CyDmaChEnable(DMA_I2S_Chan, 1);
}

/*
 * Will SPI handle a 16-bit buffer on its own, or does it require a union
 * which splits the 16 bit into two bytes? Similar to how the I2S works.
 */

void DMA_SAR_Config(void)
{
    /* Defines for DMA_SAR */
    #define DMA_SAR_BYTES_PER_BURST 2
	#define DMA_SAR_REQUEST_PER_BURST 1
	#define DMA_SAR_SRC_BASE (CYDEV_PERIPH_BASE)
	#define DMA_SAR_DST_BASE (CYDEV_SRAM_BASE)
    
    /* DMA_SAR Channel configuration */
	DMA_SAR_Chan = DMA_SAR_DmaInitialize(DMA_SAR_BYTES_PER_BURST, DMA_SAR_REQUEST_PER_BURST, 
								 HI16(DMA_SAR_SRC_BASE), HI16(DMA_SAR_DST_BASE));
    
    /* TD allocation */
    DMA_SAR_TD[0] = CyDmaTdAllocate();
    DMA_SAR_TD[1] = CyDmaTdAllocate();
    
    /* TD configuration settings */
    CyDmaTdSetConfiguration(DMA_SAR_TD[0], 2, DMA_SAR_TD[1], CY_DMA_TD_INC_DST_ADR);
	CyDmaTdSetConfiguration(DMA_SAR_TD[1], 2, DMA_SAR_TD[0], CY_DMA_TD_INC_DST_ADR);
    
    /* Set Source and Destination address of each TD */
    CyDmaTdSetAddress(DMA_SAR_TD[0], LO16((uint32)ADC_SAR_SAR_WRK0_PTR), LO16((uint32)&TXbuffer0.in));
	CyDmaTdSetAddress(DMA_SAR_TD[1], LO16((uint32)ADC_SAR_SAR_WRK0_PTR), LO16((uint32)&TXbuffer1.in));
    
    /* TD initialization */
    CyDmaChSetInitialTd(DMA_SAR_Chan, DMA_SAR_TD[0]);
    
    /* Enable the DMA channel */
    CyDmaChEnable(DMA_SAR_Chan, 1);
}

void DMA_SPIS_RX_Config(void)
{
    /* Defines for DMA_SPIS_RX */
    #define DMA_SPIS_RX_BYTES_PER_BURST 2
    #define DMA_SPIS_RX_REQUEST_PER_BURST 1
    #define DMA_SPIS_RX_SRC_BASE (CYDEV_PERIPH_BASE)
    #define DMA_SPIS_RX_DST_BASE (CYDEV_SRAM_BASE)
       
    /* DMA_SPIS_RX Channel configuration */
    rxChannel = DMA_SPIS_RX_DmaInitialize(DMA_SPIS_RX_BYTES_PER_BURST, DMA_SPIS_RX_REQUEST_PER_BURST,
                                     HI16(DMA_SPIS_RX_SRC_BASE), HI16(DMA_SPIS_RX_DST_BASE));
    
    /* TD allocation */
    rxTD = CyDmaTdAllocate();
    
    /* TD configuration settings */
    CyDmaTdSetConfiguration(rxTD, BUFFER_SIZE, CY_DMA_DISABLE_TD, TD_INC_DST_ADR);
    
    /* Set Source and Destination address of each TD */
    CyDmaTdSetAddress(rxTD, LO16((uint32) SPI_Slave_RXDATA_PTR), LO16((uint32) rxBuffer));
    
    /* TD initialization */
    CyDmaChSetInitialTd(rxChannel, rxTD);  
}

void DMA_SPIS_TX_Config(void)
{
    /* Defines for DMA_SPIS_TX */
    #define DMA_SPISlave_TX_BYTES_PER_BURST 2
    #define DMA_SPISlave_TX_REQUEST_PER_BURST 1
    #define DMA_SPISlave_TX_SRC_BASE (CYDEV_SRAM_BASE)
    #define DMA_SPISlave_TX_DST_BASE (CYDEV_PERIPH_BASE)
    
    /* DMA_SPIS_TX Channel configuration */
	txChannel = DMA_SPIS_TX_DmaInitialize(DMA_SPISlave_TX_BYTES_PER_BURST, DMA_SPISlave_TX_REQUEST_PER_BURST, 
                                              HI16(DMA_SPISlave_TX_SRC_BASE), HI16(DMA_SPISlave_TX_DST_BASE));
    
    /* TD allocation */
    txTD[0] = CyDmaTdAllocate();
    txTD[1] = CyDmaTdAllocate();
    txTD[2] = CyDmaTdAllocate();
    txTD[3] = CyDmaTdAllocate();
    
    /* TD configuration settings */
    CyDmaTdSetConfiguration(txTD[0], (BUFFER_SIZE-1), txTD[1], TD_INC_SRC_ADR);
    CyDmaTdSetConfiguration(txTD[1], (BUFFER_SIZE-1), txTD[2], TD_INC_SRC_ADR);
    CyDmaTdSetConfiguration(txTD[2], (BUFFER_SIZE-1), txTD[3], TD_INC_SRC_ADR);
    CyDmaTdSetConfiguration(txTD[3], (BUFFER_SIZE-1), txTD[0], TD_INC_SRC_ADR);
    
    /* Set Source and Destination address of each TD */
    CyDmaTdSetAddress(txTD[0], LO16((uint32) &TXbuffer0.out[0]), LO16((uint32) SPI_Slave_TXDATA_PTR));
    CyDmaTdSetAddress(txTD[1], LO16((uint32) &TXbuffer0.out[1]), LO16((uint32) SPI_Slave_TXDATA_PTR));
    CyDmaTdSetAddress(txTD[2], LO16((uint32) &TXbuffer1.out[0]), LO16((uint32) SPI_Slave_TXDATA_PTR));
    CyDmaTdSetAddress(txTD[3], LO16((uint32) &TXbuffer1.out[1]), LO16((uint32) SPI_Slave_TXDATA_PTR));
    
    /* TD initialization */
    CyDmaChSetInitialTd(txChannel, txTD[0]);    
}
/* [] END OF FILE */
