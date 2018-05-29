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
void DmaTxConfiguration(void);
void DmaAdcConfiguration(void);
/* Variable declarations for DMA_1 */
/* Move these variable declarations to the top of the function */
uint8 DMA_1_Chan;
uint8 DMA_1_TD[1];
uint8 adc_buff[2]={1,8};

/* Variable declarations for DMA_TX */
/* Move these variable declarations to the top of the function */
uint8 DMA_TX_Chan;
uint8 DMA_TX_TD[2];

int main(void)
{
    CyGlobalIntEnable; /* Enable global interrupts. */

    /* Place your initialization/startup code here (e.g. MyInst_Start()) */
    SPIS_Start();
    SPIS_WriteTxDataZero(0x00u);
    ADC_SAR_1_Start();
    ADC_SAR_1_StartConvert();
     DmaTxConfiguration();
     DmaAdcConfiguration();
    for(;;)
    {
        /* Place your application code here. */
    }
}


void DmaAdcConfiguration(){
/* Defines for DMA_1 */
#define DMA_1_BYTES_PER_BURST 2
#define DMA_1_REQUEST_PER_BURST 1
#define DMA_1_SRC_BASE (CYDEV_PERIPH_BASE)
#define DMA_1_DST_BASE (CYDEV_SRAM_BASE)


/* DMA Configuration for DMA_1 */
DMA_1_Chan = DMA_1_DmaInitialize(DMA_1_BYTES_PER_BURST, DMA_1_REQUEST_PER_BURST, 
    HI16(DMA_1_SRC_BASE), HI16(DMA_1_DST_BASE));
DMA_1_TD[0] = CyDmaTdAllocate();
CyDmaTdSetConfiguration(DMA_1_TD[0], 2, DMA_1_TD[0], 0);
CyDmaTdSetAddress(DMA_1_TD[0], LO16((uint32)ADC_SAR_1_SAR_WRK0_PTR), LO16((uint32)adc_buff));
CyDmaChSetInitialTd(DMA_1_Chan, DMA_1_TD[0]);
CyDmaChEnable(DMA_1_Chan, 1);
};
void DmaTxConfiguration(){
/* Defines for DMA_TX */
#define DMA_TX_BYTES_PER_BURST 1
#define DMA_TX_REQUEST_PER_BURST 1
#define DMA_TX_SRC_BASE (CYDEV_SRAM_BASE)
#define DMA_TX_DST_BASE (CYDEV_PERIPH_BASE)



/* DMA Configuration for DMA_TX */
DMA_TX_Chan = DMA_TX_DmaInitialize(DMA_TX_BYTES_PER_BURST, DMA_TX_REQUEST_PER_BURST, 
    HI16(DMA_TX_SRC_BASE), HI16(DMA_TX_DST_BASE));
DMA_TX_TD[0] = CyDmaTdAllocate();
DMA_TX_TD[1] = CyDmaTdAllocate();
CyDmaTdSetConfiguration(DMA_TX_TD[0], 1, DMA_TX_TD[1], 0);
CyDmaTdSetConfiguration(DMA_TX_TD[1], 1, DMA_TX_TD[0], 0);
CyDmaTdSetAddress(DMA_TX_TD[0], LO16((uint32)&adc_buff[1]), LO16((uint32)SPIS_TXDATA_PTR));
CyDmaTdSetAddress(DMA_TX_TD[1], LO16((uint32)&adc_buff[0]), LO16((uint32)SPIS_TXDATA_PTR));
CyDmaChSetInitialTd(DMA_TX_Chan, DMA_TX_TD[1]);
CyDmaChEnable(DMA_TX_Chan, 1);
};

/* [] END OF FILE */
