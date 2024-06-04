*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG   $3000

a DC.w 1,5,3,-7                                         *declare the first array
b DC.w 0,4,3,-1                                         *declare the second array
c DC.w -1,2,3,6                                         *declare the third array
dim_a DC.w 4                                            *declare dimension of the first array
dim_b DC.w 4                                            *declare dimension of the second array
dim_c DC.w 4                                            *declare dimension of the third array
ris DS.w 1                                              *declare space in memory for result
sub_reg REG A0-A5/D0-D4                                 *subroutine registers
dim_a_offset EQU 24                                     *offset of the dimension a
dim_b_offset EQU 16                                     *offset of the dimension b
dim_c_offset EQU 8                                      *offset of the dimension c
a_offset EQU 28                                         *array a offset
b_offset EQU 20                                         *array b offset
c_offset EQU 12                                         *array c offset
ris_offset EQU 30                                       *result space offset



    ORG   $2000
SAME LINK A6,#0                                        *create frame pointer
     MOVEM.l sub_reg,-(SP)                             *save context
     MOVEA.l dim_a_offset(A6),A0                       *load from stack the dimension
     MOVEA.l dim_b_offset(A6),A1                       *load from stack the dimension
     MOVEA.l dim_c_offset(A6),A2                       *load from stack the dimension
     MOVEA.l a_offset(A6),A3                           *load from stack element of the array
     MOVEA.l b_offset(A6),A4                           *load from stack element of the array
     MOVEA.l c_offset(A6),A5                           *load from stack element of the array
     MOVE.w (A0),D0                                    *load the dimension in a data register
     MOVE.w (A1),D1                                    *load the dimension in a data register
     MOVE.w (A2),D2                                    *load the dimension in a data register
     CMP.w D0,D1                                       *check if the first and second array have the same dimension
     BNE FINE                                          *if they dont end the program
     CMP.w D1,D2                                       *check if the second and third array have the same dimension
     BNE FINE                                          *if they dont end the program
     CLR.l D0                                          *clean the register used 
     CLR.l D1                                          *clean the register used
     CLR.l D2                                          *clean the register used
     MOVE.w (A0),D4                                    *save the general dimension in D4
     SUBQ #1,D4                                        *prepare for DBRA usage
     


LOOP MOVE.w (A5),D2                                    *move array element in data register
     MOVE.w (A4),D1                                    *move array element in data register
     MOVE.w (A3),D0                                    *move array element in data register
     CMP.w D1,D2                                       *check if the element of the third array is smaller
     BLE LESSUPDATE1                                   *if it is update
TEST CMP.w D0,D1                                       *check if the element of the second array is smaller than the first one                        
     BLE LESSUPDATE2                                   *if it is update
TEST2 CMP.w D1,D2                                      *check again between the third and the second after the updates                                    
      BLE LESSUPDATE3                                  *if it is update
LOOPBACK DBRA D4,LOOP                                  *loop back to the head

     MOVE.w #1,ris_offset(A6)                         *push the result in the stack
FINE MOVEM.l (SP)+,sub_reg                             *restore context                      
     UNLK A6                                           *destroy frame pointer
     RTS                                               *return

*switch the value of the n-element of the second and third array
LESSUPDATE1 MOVE.w D2,(A4)
            MOVE.w D1,(A5)
            MOVE.w D2,D3
            MOVE.w D1,D2
            MOVE.w D3,D1
            CLR.l D3
            BRA TEST
            
*switch the value of the n-element of the second and first array          
LESSUPDATE2 MOVE.w D1,(A3)+
            MOVE.w D1,D3
            MOVE.w D0,D1
            MOVE.w D3,D0
            CLR.l D3
            BRA TEST2
            
*switch the value of the n-element of the second and third array
LESSUPDATE3 MOVE.w D2,(A4)+
            MOVE.w D1,(A5)+
            MOVE.w D2,D3
            MOVE.w D1,D2
            MOVE.w D3,D1
            CLR.l D3
            BRA LOOPBACK
  
     
     
    ORG    $1000
    
START ADDA.l #-2,SP                                     *reserve space on the stack for the result
      PEA a                                             *push address in the stack
      PEA dim_a                                         *push address in the stack
      PEA b                                             *push address in the stack
      PEA dim_b                                         *push address in the stack
      PEA c                                             *push address in the stack
      PEA dim_c                                         *push address in the stack
      JSR SAME                                          *calls the subroutine
      ADDA.l #24,SP                                     *restore the stack pointer to the return value of the subroutine
      LEA RIS,A0                                        *load the space of memory in wich we want to save the result
      MOVE.w -2(SP),(A0)                                *saves the results
    SIMHALT

    END    START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
