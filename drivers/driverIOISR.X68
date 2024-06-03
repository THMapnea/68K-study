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

    
    ORG    $4000 
ISR MOVEA.l #pdata,A0                                               *load the address of the data stored in the device
    MOVE.b  #$01,1(A0)                                              *signals in the control register that it has received the data
    RTE                                                             *return from the exeptcion handler
    


    ORG    $1000
    
START MOVEA.l #pdata,A0                                             *load the address of the driver data space in A0
      LEA v,A1                                                      *load the address pf v in A1
      MOVE.b  (A1),(A0)                                             *move the value inside the data register of the driver
      MOVE.b #$01,1(A0)                                             *load in the control register the value of 1,to acces the control register we increased by one A0,this tells to the interface that we wrote the data
      
HALT JMP HALT                                                       *the CPU will now wait to receive information from the peripheral                                                         


    SIMHALT             


    END    START        


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
