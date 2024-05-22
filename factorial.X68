*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

    ORG    $3000
number DC.w 5                                                                   *declare a number that i want to make the factorial
factorial DCB.w 1,1                                                              *declare a memory pace in wich we save the factorial of our number, initialized at one
sub_reg REG A0-A1/D0-D1                                                         *declare the register used by the subroutine
number_offset EQU 12                                                            *number offset
factorial_offset EQU 8                                                          *factorial offset




    ORG    $2000
COMPUTEFACTORIAL:
    LINK A6,#0                                                                  *create the frame pointer
    MOVEM.l sub_reg,-(SP)                                                       *save context
    MOVEA.l number_offset(A6),A0                                                *move the number address in a address register
    MOVEA.l factorial_offset(A6),A1                                             *move the factorial address in a address register 
    MOVE.w (A0),D0                                                              *move number value in data register
    MOVE.w (A1),D1                                                              *pass the value of the actual factorial
    
    MULS D0,D1                                                                  *multiply D1 with D0
    SUBQ #1,D0                                                                  *decrease D0
    MOVE.w D0,(A0)                                                              *save new value of D0 in memory
    MOVE.w D1,(A1)                                                              *save new value of factorial in memory
    CMP #0,D0                                                                   *check if i made it till the end of the multiplications
    
    MOVEM.l (SP)+,sub_reg                                                       *restore context
    UNLK A6                                                                     *destroy the frame pointer
    
    BNE COMPUTEFACTORIAL                                                        *if not recursive call the function
                      
    RTS                                                                         *return










    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    PEA number                                                                  *push the number address in to the stack
    PEA factorial                                                               *push the address of the result in to the stack
    JSR COMPUTEFACTORIAL                                                               *call the subroutine
    ADDA.l #8,SP                                                                *ripristino lo stack pointer
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
