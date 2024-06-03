*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
pdata EQU $2000                                                     *data register of the memory mapped I/O driver with polling architecture
pctrl EQU $2001                                                     *control register of the memory mapped I/O driver with polling architecture
pstatus EQU $2002                                                   *status register of the memory mapped I/O driver with polling architecture

    ORG    $3000
    
v DC.b 10                                                           *example value 




    ORG    $1000
    
START MOVEA.l #pdata,A0                                             *load the address of the driver data space in A0
      LEA v,A1                                                      *load the address pf v in A1
      MOVE.b  (A1),(A0)                                             *move the value inside the data register of the driver
      MOVE.b #$01,1(A0)                                             *load in the control register the value of 1,to acces the control register we increased by one A0,this tells to the interface that we wrote the data
      
LOOP  MOVE.b 2(A0),D0                                               *we load the response from the status register of the driver in D0
      ANDI.b #$01,D0                                                *and immediate with the data register to simulate that the device responded
      BEQ LOOP                                                      *we wait until the CPU sees that it got a response from the device

      MOVE.b #$0,1(A0)                                              *the CPU resets the device to make it available for the next process

    SIMHALT             


    END    START        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
