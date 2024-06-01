
    ORG   $3000
array DC.w 12,23,44,55,76,43,90,18                                                                      *declare our array of word coded numbers
max EQU 220                                                                                             *define the total that we want to check for
index DS.l 1                                                                                            *define the memory space where to save the index in the moment that we go over the max    
sub_reg REG A0-A2/D0-D3                                                                                 *register used by the subroutine
array_offset EQU 16                                                                                     *array offset
index_offset EQU 12                                                                                     *index offset
max_offset EQU 8                                                                                        *max offset
sum_offset EQU 20                                                                                       *sum offset


    ORG    $2000
CALCULATE LINK A6,#0                                                                                    *create frame pointer
          MOVEM.l sub_reg,-(SP)                                                                         *save the context
          MOVE.l array_offset(A6),A0                                                                    *pop the array addres in A0
          MOVE.l index_offset(A6),A1                                                                    *pop the index address in A1
          MOVE.l max_offset(A6),D0                                                                      *pop the value of the max
          MOVE.l #0,D2                                                                                  *initialize the counter
          MOVE.l #-1,D3                                                                                 *initialize the index counter
ARRAYLOOP CMP.w D0,D2                                                                                   *check if the sum has overflowed the max 
          BGT TERMINATE                                                                                 *if we overflowed from the max we exit
          MOVE.w (A0)+,D1                                                                               *we move the element of the array in D1
          ADD.w  D1,D2                                                                                  *sum the two values
          ADDQ #1,D3                                                                                    *increment the index that we are now
          BRA ARRAYLOOP                                                                                 *go back to the top
            
          
TERMINATE MOVE.l D2,sum_offset(A6)                                                                      *push in to the stack the result
          MOVE.l D3,(A1)                                                                                *load the index in the memory
          MOVEM.l (SP)+,sub_reg                                                                         *restore of the context
          UNLK A6                                                                                       *destroy frame pointer                                                                                      
          RTS                                                                                           *return of the subroutine    







    ORG    $1000
START ADDA.l #-4,SP                                                                                     *reserve four spaces for the sum that is the output parameter of the subroutine
      PEA array                                                                                         *push of the effective address of the array in to the stack 
      PEA index                                                                                         *push in to the stack the effective address of the result memory space
      MOVE.l #max,-(SP)                                                                                 *move the max parameter value in the stack  
      JSR CALCULATE                                                                                     *calls the subroutine
      ADDA.l #16,SP                                                                                     *restore the stack pointer
      MOVE.l -4(SP),D0                                                                                  *load the resulting sum in a register to see it





    SIMHALT             
    END    START        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
