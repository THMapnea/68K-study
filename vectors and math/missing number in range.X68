*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG   $3000

array DC.b 0,1,2,4                                                                          *initialize our array of n integer defined as a range with one missing element
dim EQU 4                                                                                   *initialize the dimension of the array
missing_number DS.w 1                                                                       *storage space for the missing number
sub_reg REG A0-A2/D0-D3                                                                     *subroutine registers
dim_offset EQU 16                                                                           *dimension offset
array_offset EQU 12                                                                         *array offset
missing_number_offset EQU 8                                                                 *missing number offset



    ORG   $2000
    
SEARCH LINK A6,#0                                                                          *create the frame pointer
       MOVEM.l sub_reg,-(SP)                                                               *save the context
       MOVEA.l array_offset(A6),A0                                                         *move the array element address in A0
       MOVEA.l missing_number_offset(A6),A1                                                *move the storage space address in A1
       MOVE.w dim_offset(A6),D0                                                            *load the dimension in D0
       MOVE.w D0,D1                                                                        *use the D1 register to hold the copy of the dimension
       ADDQ #1,D1                                                                          *increase D1 by one
       MULS D0,D1                                                                          *multiply D0 and D1 and save in D1
       DIVS #2,D1                                                                          *floor divide by 2
       SUBQ #1,D0                                                                          *decrease D0 for DBRA use
       CLR.l D3                                                                            *clear D3 to store the sum
SUMLOOP MOVE.b (A0)+,D2                                                                    *load the element of the array
        ADD.b D2,D3                                                                        *sum to D3 the number of the array
        DBRA D0,SUMLOOP                                                                    *loop trough the array
       SUB D3,D1                                                                           *subtract the sum of the array with the value in D1
       MOVE.w D1,(A1)                                                                      *save the number      
       MOVEM.l (SP)+,sub_reg                                                               *restore the context
       UNLK A6                                                                             *destroy the frame pointer
       RTS                                                                                 *return



    ORG    $1000
    
START MOVE.w #dim,-(SP)                                                                     *load the dimension in the stack
      PEA array                                                                             *push the effective address of the array in the stack
      PEA missing_number                                                                    *push the effective address of the result space in the array
      JSR SEARCH                                                                            *call the subroutine
      ADDA.l #12,SP                                                                         *restore the stack pointer

    SIMHALT
    END    START        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
