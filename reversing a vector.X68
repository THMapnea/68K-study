*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

    ORG    $3000
    
vector DC.b 1,2,3,4,5,6,7,8,9                               *declare a vector
dim DC.b 9                                                  *take the dimension of the vector 
reversed_vector DS.b 8                                      *create a storage space od dimension N=dim to store reversed array
sub_reg REG A0-A2/D0-D2                                     *subroutine registers
vector_offset EQU 16                                        *vector offset
dim_offset EQU 12                                           *dimension offset
reversed_vector_offset EQU 8                                *reversed vector offset




    ORG    $2000

REVERSE:
    LINK A6,#0                                              *create the frame pointer
    MOVEM.l sub_reg,-(SP)                                   *save context
    MOVEA.l vector_offset(A6),A0                            *move vector address from stack to address register 
    MOVEA.l dim_offset(A6),A1                               *move dim address from stack to address register
    MOVEA.l reversed_vector_offset(A6),A2                   *move reversed vector address to address register
    MOVE.b (A1),D1                                          *move the dimension in a data register
    ADDA.l D1,A2                                            *we add the dimension to the register containing the address of the reversed array storage so that we can loop it back
    LOOP:
        MOVE.b (A0)+,-(A2)                                  *we increment the element that is in the original array and decrement the reversed one
        DBRA D1,LOOP                                        *if we have not looped the entire array we go back
    
    
    
    
    MOVEM.l (SP)+,sub_reg                                   *restore context
    UNLK A6                                                 *destroy framepointer
    RTS                                                     *return






    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    PEA vector                                              *push vector addres in to the stack
    PEA dim                                                 *push dimension addres in to the stack
    PEA reversed_vector                                     *push reversed vector address in the stack
    JSR REVERSE                                             *calls the subroutine 
    ADDA.l #12,SP                                            *restore the stack
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
