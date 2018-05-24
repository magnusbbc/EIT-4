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
#include "project.h"
#include <DMA_dma.h>
#include <DMA_1_dma.h>
#include <ADC.h>
#define LUTSize 96
#define DMAon 1
#define ADCon 0

void DMA_Config(void);



uint8 c;
uint8_t flag = 0;
/* Variable declarations for DMA */
/* Move these variable declarations to the top of the function */
uint8 DMA_Chan;
uint8 DMA_TD[2];
/* Variable declarations for DMA_1 */
/* Move these variable declarations to the top of the function */
uint8 DMA_1_Chan;
uint8 DMA_1_TD[4];

union buffer{
    uint16 in;
    uint8 out[2];
};
uint16 sineLUT[LUTSize] ={0, 523, 1044, 1560, 2070, 2571, 3061, 3538, 3999, 4444, 4870, 5274, 5656, 6014, 6346, 6651, 6928, 7174, 7391, 7575, 7727, 7846, 7931, 7982, 8000, 7982, 7931, 7846, 7727, 7575, 7391, 7174, 6928, 6651, 6346, 6014, 5656, 5274, 4870, 4444, 3999, 3538, 3061, 2571, 2070, 1560, 1044, 523, 0, -523, -1044, -1560, -2070, -2571, -3061, -3538, -4000, -4444, -4870, -5274, -5656, -6014, -6346, -6651, -6928, -7174, -7391, -7575, -7727, -7846, -7931, -7982, -8000, -7982, -7931, -7846, -7727, -7575, -7391, -7174, -6928, -6651, -6346, -6014, -5656, -5274, -4870, -4444, -4000, -3538, -3061, -2571, -2070, -1560, -1044, -523};
//uint16 sineLUT[LUTSize] ={101,102,1023};
union buffer buf;
union buffer buffer0, buffer1;


int main(void)
{
    CyGlobalIntEnable; /* Enable global interrupts. */

    //buffer0.in=10;
    ADC_Start();
    ADC_StartConvert();
    I2S_1_Start();
#if DMAon
    DMA_Config();
#endif
    I2S_1_EnableTx();

    
    
    /* Place your initialization/startup code here (e.g. MyInst_Start()) */

    for(;;)
    {
       
        #if !DMAon
       
          if(I2S_1_ReadTxStatus(CH0)&I2S_1_TX_FIFO_0_NOT_FULL){ 
            if(flag){
                 flag = 0;
                buf.in = ADC_GetResult16();
                I2S_1_WriteByte(buf.out[flag],0);
           // c++;
            //I2S_1_WriteByte(0,0);
                
           
            }else{
              flag =1;
            I2S_1_WriteByte(buf.out[flag],0);
          //I2S_1_WriteByte(sine[c],0);
        
        }
        
       //   I2S_1_WriteByte(ADC_Read8(),1);
        
        }
        #endif
        //I2S_1_WriteByte(0,1);
  
        /* Place your application code here. */
    }





}
void DMA_Config(void){
/* Defines for DMA */
#define DMA_BYTES_PER_BURST 2
#define DMA_REQUEST_PER_BURST 1
#if ADCon    
#define DMA_SRC_BASE (CYDEV_PERIPH_BASE)
#else
#define DMA_SRC_BASE (CYDEV_SRAM_BASE)
#endif
#define DMA_DST_BASE (CYDEV_SRAM_BASE)

#if ADCon
/* DMA Configuration for DMA */
DMA_Chan = DMA_DmaInitialize(DMA_BYTES_PER_BURST, DMA_REQUEST_PER_BURST, 
    HI16(DMA_SRC_BASE), HI16(DMA_DST_BASE));
DMA_TD[0] = CyDmaTdAllocate();
DMA_TD[1] = CyDmaTdAllocate();
CyDmaTdSetConfiguration(DMA_TD[0], 2, DMA_TD[1], CY_DMA_TD_INC_DST_ADR);
CyDmaTdSetConfiguration(DMA_TD[1], 2, DMA_TD[0], CY_DMA_TD_INC_DST_ADR);
CyDmaTdSetAddress(DMA_TD[0], LO16((uint32)ADC_DEC_SAMP_PTR), LO16((uint32)&buffer0.in));
CyDmaTdSetAddress(DMA_TD[1], LO16((uint32)ADC_DEC_SAMP_PTR), LO16((uint32)&buffer1.in));
CyDmaChSetInitialTd(DMA_Chan, DMA_TD[0]);
CyDmaChEnable(DMA_Chan, 1);
//////////////////////////////////
#else
/* DMA Configuration for DMA */
DMA_Chan = DMA_DmaInitialize(DMA_BYTES_PER_BURST, DMA_REQUEST_PER_BURST, 
    HI16(DMA_SRC_BASE), HI16(DMA_DST_BASE));
DMA_TD[0] = CyDmaTdAllocate();
DMA_TD[1] = CyDmaTdAllocate();
CyDmaTdSetConfiguration(DMA_TD[0], LUTSize*2, DMA_TD[0], CY_DMA_TD_INC_SRC_ADR);
CyDmaTdSetConfiguration(DMA_TD[1], LUTSize*2, DMA_TD[0], CY_DMA_TD_INC_SRC_ADR);
CyDmaTdSetAddress(DMA_TD[0], LO16((uint32)sineLUT), LO16((uint32)&buffer0.in));
CyDmaTdSetAddress(DMA_TD[1], LO16((uint32)sineLUT), LO16((uint32)&buffer1.in));
CyDmaChSetInitialTd(DMA_Chan, DMA_TD[0]);
CyDmaChEnable(DMA_Chan, 1);
//////////////////////////////////
#endif



/* Defines for DMA_1 */
#define DMA_1_BYTES_PER_BURST 1
#define DMA_1_REQUEST_PER_BURST 1
#define DMA_1_SRC_BASE (CYDEV_SRAM_BASE)
#define DMA_1_DST_BASE (CYDEV_PERIPH_BASE)


#define bf 1
/* DMA_1 Configuration for DMA_1 */
DMA_1_Chan = DMA_1_DmaInitialize(DMA_1_BYTES_PER_BURST, DMA_1_REQUEST_PER_BURST, 
    HI16(DMA_1_SRC_BASE), HI16(DMA_1_DST_BASE));
DMA_1_TD[0] = CyDmaTdAllocate();
DMA_1_TD[1] = CyDmaTdAllocate();
DMA_1_TD[2] = CyDmaTdAllocate();
DMA_1_TD[3] = CyDmaTdAllocate();
CyDmaTdSetConfiguration(DMA_1_TD[0], 1, DMA_1_TD[1], 0);
CyDmaTdSetConfiguration(DMA_1_TD[1], 1, DMA_1_TD[0], 0);
CyDmaTdSetConfiguration(DMA_1_TD[2], 1, DMA_1_TD[3], 0);
CyDmaTdSetConfiguration(DMA_1_TD[3], 1, DMA_1_TD[0], 0);
CyDmaTdSetAddress(DMA_1_TD[0], LO16((uint32)&buffer0.out[1]), LO16((uint32)I2S_1_TX_CH0_F0_PTR));
CyDmaTdSetAddress(DMA_1_TD[1], LO16((uint32)&buffer0.out[0]), LO16((uint32)I2S_1_TX_CH0_F0_PTR));
CyDmaTdSetAddress(DMA_1_TD[2], LO16((uint32)&buffer1.out[1]), LO16((uint32)I2S_1_TX_CH0_F0_PTR));
CyDmaTdSetAddress(DMA_1_TD[3], LO16((uint32)&buffer1.out[0]), LO16((uint32)I2S_1_TX_CH0_F0_PTR));
CyDmaChSetInitialTd(DMA_1_Chan, DMA_1_TD[0]);
CyDmaChEnable(DMA_1_Chan, 1);

}

/* [] END OF FILE */
