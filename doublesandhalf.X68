*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG   $3000
    
array DC.w 12,13,23,44,55,43,98,22,33                                                                   *initialize the array as .w
dim EQU 9                                                                                               *create the dimension parameter to pass to the subroutine
updated_array DS.l 9                                                                                    *reserve space in memory to the result, initialized to 0
array_offset EQU 16                                                                                     *array offset
dim_offset EQU 12                                                                                       *dimension offset
updated_array_offset EQU 8                                                                              *updated array offset
sub_reg REG A0-A1/D0,D2                                                                                 *register used by the subroutine


    ORG   $2000
    
UPDATE LINK A6,#0                                                                                       *create the frame pointer
       MOVEM.l sub_reg,-(Sp)                                                                            *save the context
       MOVEA.l array_offset(A6),A0                                                                      *load the address of the first element of the array in A0
       MOVE.l dim_offset(A6),D2                                                                         *load the dimension of the array from the stack in D2
       MOVEA.l updated_array_offset(A6),A1                                                              *move the address of the memory space in A1

ARRAYLOOP CMP.b #0,D2                                                                                   *check if we looped trough all the array 
          BEQ TERMINATE                                                                                 *if it ends we exit from the cycle
          MOVE.w (A0)+,D0                                                                               *load in data register the array element with post increment
          DIVU #2,D0                                                                                    *divide the number to see if it is odd or even
          SWAP D0                                                                                       *swap the most significant bit containing the reminder with the least significant beat containing the result
          CMP.w #0,D0                                                                                   *check if the reminder is 0
          BEQ DIVIDE                                                                                    *if they are equal divide the value
          BNE DOUBLE                                                                                    *if they are not equal so they are odd we double the value


TERMINATE MOVEM.l (SP)+,sub_reg                                                                         *restore context
          UNLK A6                                                                                       *destroy frame pointer    
          RTS                                                                                           *return 
                    

                                                            
DIVIDE SWAP D0                                                                                          *reswap the register
       MOVE.w D0,(A1)+                                                                                  *load the value in memory
       DBRA D2,ARRAYLOOP                                                                                *go back to continue looping the array
DOUBLE CLR.l D0                                                                                         *clear D0
       MOVE.w (A0),D0                                                                                   *restore D0 value
       MULS #2,D0                                                                                       *double the value
       MOVE.l D0,(A1)+                                                                                  *save the result
       DBRA D2,ARRAYLOOP                                                                                *go back to looping the array
       


    ORG    $1000
START   PEA array                                                                                       *push the address of the array in the stack
        MOVE.l #dim,-(SP)                                                                               *move the value of the dimension in the stack
        PEA updated_array                                                                               *push the address of the results memory space in the stack
        JSR UPDATE                                                                                      *calls the subroutine
        ADDA.l #12,SP                                                                                   *restore the stack pointer


    SIMHALT  

    END    START        
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
