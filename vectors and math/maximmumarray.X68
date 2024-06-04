*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG $3000
a DC.b 1,5,6,2                                                  *declare first array
b DC.b 3,2,1,9                                                  *declare second array
dim EQU 4                                                       *declare dimension
c DS.b 4                                                        *save space in memory for result array
sub_reg REG A0-A2/D0-D2                                         *subroutine register
a_off EQU 18                                                    *offset vector a
b_off EQU 14                                                    *offset vector b
c_off EQU 10                                                    *offset vector c
dim_off EQU 8                                                   *dimension offset


    ORG   $2000
GENERATE LINK A6,#0                                             *create fram pointer
         MOVEM.l sub_reg,-(SP)                                  *save context
         MOVEA.l a_off(A6),A0                                   *move array address in A0
         MOVEA.l b_off(A6),A1                                   *move array address in A1
         MOVEA.l c_off(A6),A2                                   *move array address in A2
         MOVE.w dim_off(A6),D2                                  *move dimension in D2
         SUBQ #1,D2                                             *prepare for DBRA
LOOP MOVE.b (A0)+,D0                                            *load the element
     MOVE.b (A1)+,D1                                            *load the element
     CMP.b D0,D1                                                *check if it is greater
     BGT UPDATE                                                 *if it is update with D1
     MOVE.b D0,(A2)+                                            *if it is not update with D0
     DBRA D2,LOOP                                               *loop back

UPDATE MOVE.b D1,(A2)+                                          *save in memory
       DBRA D2,LOOP                                             *loop back
       
         MOVEM.l (SP)+,sub_reg                                  *restore context
         UNLK A6                                                *destroy frame pointer
         RTS                                                    *return




    ORG    $1000
START PEA a                                                     *push address of array in the stack
      PEA b                                                     *push address of array in the stack
      PEA c                                                     *push address of array in the stack
      MOVE.w #dim,-(SP)                                         *push dimension in the stack
      JSR GENERATE                                              *call subroutine
      ADDA.l #14,SP                                             *restore stack pointer

    SIMHALT 

    END    START        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
