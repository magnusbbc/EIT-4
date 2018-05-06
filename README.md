# EIT-4 BEN Processor
This repository contains the files required to synthesize the BEN CPU onto a TERASIC DE0 (Cyclone III). All the VHDL design files are stored in the "VHDL" folder. A simple assembler for the BEN CPU's instruction set is also made available, source files can be found under "Assembler". PSoC code (for the Cypress LP5) for sampling and sending data to the FPGA/CPU is found under "PSoC". PCB/3D Print/laser engraving files are found in "Fabrication". Finally, documentation for the project is contained in the documentation folder

## Getting Started
These instructions will get you a copy of the project up and running on your own hardware for development and testing purposes.
### Prerequisites
**Hardware requirements:**
* [CY8CKIT-059 PSoC 5LP Prototyping Kit](http://www.cypress.com/documentation/development-kitsboards/cy8ckit-059-psoc-5lp-prototyping-kit-onboard-programmer-and) 
* [Terasic DE0](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=364)
* [Adafruit I2S Stereo Decoder](https://www.adafruit.com/product/3678)
* Various electronic components (Full list can be found in the "Documentation" Directory)


**Software requirements:**
* [PSoC Creator](http://www.cypress.com/products/psoc-creator-integrated-design-environment-ide) (Only tested and verified on Version 4.2)
* [Altera Quartus II 13.1, Web Edition, with Cyclone III Device Support](https://dl.altera.com/13.1/)
* * [Model-Sim Altera](https://dl.altera.com/13.1/) (Optional)
* C compiler
* [GPP](https://logological.org/gpp) - Windows Binaries can be found [here](https://github.com/makc/gpp.2.24-windows/releases)
### Installing
This installation guide only applies for a windows installation.
**Synthesising VHDL and Uploading to the DE0**
Before creating a new VHDL project in Quartus, we need to generate our raw source files by running our .vhd files through the Generic Preprocessor (GPP). To make this part easier, a "PreProcessorWindows.bat" script is included in the repository. To use the script, change the output directory to match your own directory of choice, and then execute the script (NOTE: make sure you have added GPP.exe to your Environment Path)
![alt text](https://i.imgur.com/tedi0QC.png "Pre Processor Script")

Now we are ready to create new VHDL project in Quartus.
Create a new project using the built in "New Project Wizard". The wizard has four pages of project configuration settings that can be modified. In each settings-page do the following:
1. Select any project directory of your choice
2. Add all the source files generated using GPP:
    * Control.vhd
    * Stack.vhd
    * ALU.vhd
    * Master.vhd
    * MemoryController.vhd
    * Memory.vhd
    * RegistryInternal.vhd
    * btndriver.vhd
    * b2bcd.vhd
    * ssgddriver.vhd
    * Interrupt.vhd
    * I2SDriverIn.vhd
    * I2SDriverOut.vhd
    * I2SMonoIn.vhd
    * I2SMonoOut.vhd
    
    Additionally add the following files from the Git Repository:
    * VHDL/IP_Cores/Multiplier_1.qip
    * VHDL/IP_Cores/PLL.qip
    * VHDL/IP_Cores/MemAuto.qip
    * VHDL/IP_Cores/MemInit.mif

    It should look something like this:
![alt text](https://i.imgur.com/C6RFKE3.png "VHDL Files to ADD")
3. When selecting device:
    * Select "Cyclone III" under "device family"
    * Under "Target Device" select "Specific device selecten in 'Available devices' list"
    * Then select "EP3C16F484C6 in the "Available Devices" window
    * For "Package", "Pin count" and "Speed grade", pick "Any"
    
    The window should look like this:
    ![alt text](https://i.imgur.com/wfat18W.png "VHDL Files to ADD")
4. The final settings tab requires you to select EDA and synthesis tools:
    * In the "Design Entry/Synthesis" row, select "Custom" in the tool column, and "EDIF in the "Format(s)" column
    * In the "simulation" row, select "ModelSim-Altera" in the tool column, and "VHDL in the "Format(s)" column
    * Pick <None> in all other boxes

    Again, make sure you settings match the screenshot below:
    ![alt text](https://i.imgur.com/9VW5DGv.png "VHDL Files to ADD")
    
Now you are finished creating the project, and all relevant files should be present.
Before compiling the project, make sure to set "Master.vhd" as the top level entity, as shown in the screenshot below:
![Alt Text](https://i.imgur.com/Ri8cTzm.png)

To compile the project, double click the compile button (note that this may take several minutes):
![Alt Text](https://i.imgur.com/YCjijzB.gif)

Finally, to upload the synthesized cpu to the DEO FPGA, double click on "Program Device (Open Programmer)" and then press start:
![Alt Text](https://i.imgur.com/V1K12Ag.gif)

## Assembly Programming

## Authors

* **Frederik Skyt Dæncker Rasmussen**
* **Jakob Karup Thomsen**
* **Mikkel Hardysøe**
* **Max Wæhrens**
* **Peter Fisker**
* **Magnus B.B. Christensen**
