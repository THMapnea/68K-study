*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG   $3000
dim DC.w 17                                                                         *array dimension  
array DC.b 3,6,9,7,0,2,1,23,12,23,45,66,66,0,-2,-3,5                                *array to sort
sub_reg REG A0/D0-D5                                                                *register used by subroutine
array_offset EQU 8                                                                  *array offset




    ORG   $2000
    
SWITCH:
    MOVE.b D0,D3                                                                    *save D0 value in D3
    MOVE.b D1,D0                                                                    *set D0 to the value of D1
    MOVE.b D3,D1                                                                    *set the value of D1 to D0
    MOVE.b D0,-(A0)                                                                 *move back in memory with pre decrement the value of D0 
    MOVE.b D1,1(A0)                                                                 *move in the memory with one increment the value of D1 
    CLR D3                                                                          *clean D3
        BRA TEST

BUBBLESORT:
    LINK A6,#0                                                                      *create frame pointer
    MOVEM.l sub_reg,-(SP)                                                           *save context
    MOVEA.l array_offset(A6),A0                                                     *load the address of the first element of the array in an address register
    

    LOOP:
        CMP #1,D4                                                                   *check if we looped trough all the array we check with one because otherwise we will take also the element after the last one
        BEQ TERMINATE                                                               *if we did we go back to the recursion
        SUBQ #1,D4                                                                  *decrese D4 to check if we have gone trough all the array
        MOVE.b (A0)+,D0                                                             *move the current element and increment
        MOVE.b (A0),D1                                                              *move the element to compare
        CMP.b D0,D1                                                                 *check if D1 is smaller than D0
        BLT SWITCH                                                                  *if it is smaller switch their position
    TEST: 
        BRA LOOP                                                                    *if we havent reach the end we redo it
    TERMINATE: 
        MOVEM.l (SP)+,sub_reg                                                       *restore context
        UNLK A6                                                                     *destroy frame pointer
        DBRA D5,BUBBLESORT                                                          *repeat
    RTS                                                                             *return    




    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    LEA dim,A1                                                                      *load the dimension
    MOVE.w (A1),D4                                                                  *move the dimension in D4
    MOVE.w D4,D5                                                                    *move the dimensioni n an auxiliary register
    MULS D5,D5                                                                      *worst case scenario O(N^2)
    PEA array                                                                       *push array in to the stack
    JSR BUBBLESORT                                                                  *call the subroutine
    ADDA.l #4,SP                                                                    *restore the stack
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
