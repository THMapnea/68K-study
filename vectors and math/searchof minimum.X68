*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG     $3000
    
vector DC.b 1,2,3,4,5,6,7,8,9,0,-1,-3,12                        *initialize the vector
dim DC.b 12                                                     *dimension of the vector -1 because we are going to use DBRA
min DS.b 1                                                      *space in memory to save min
min_index DS.b 1                                                *space in memory to save min index
sub_reg REG A0-A3/D0-D4                                         *register used in subroutine
vector_offset EQU 20                                            *offset vector
dim_offset EQU 16                                               *offset dimension
min_offset EQU 12                                               *offset minimuj
min_index_offset EQU 8                                          *min index offset


    ORG     $2000
    
UPDATE:
    MOVE.b D0,D2                                                *move the new minimum in D2
    MOVE.b D4,D3                                                *adjust the min index value
    BRA TEST2                                                   *branch back to decrement                                                       
                       
SEARCHMINIMUM:
    LINK A6,#0                                                  *create the frame pointer                                      
    MOVEM.l sub_reg,-(SP)                                       *save the context
    MOVEA.l vector_offset(A6),A0                                *pop from the stack in to the address register
    MOVEA.l dim_offset(A6),A1                                   *pop from the stack in to the address register
    MOVEA.l min_offset(A6),A2                                   *pop from the stack in to the address register
    MOVEA.l min_index_offset(A6),A3                             *pop from the stack in to the address register
    MOVE.b (A1),D1                                              *save the dimension in D1
    MOVE.b (A0),D2                                              *save the first value as minimum in D2
    MOVE.b #0,D5                                                *save as min index the first one
    
    
    LOOP:
        ADDQ #1,D4                                              *incremento il counter dell index
        MOVE.b (A0)+,D0                                         *move the element in the data register
    TEST1: CMP.b D2,D0                                          *compare the actual element with the minimum
    BLE   UPDATE                                                *check if it is smaller 
    TEST2: DBRA D1,LOOP                                         *check if we have looped trough all the array
    
    MOVE.b D2,(A2)                                              *move the minimum in memory
    MOVE.b D3,(A3)                                              *move the minimum index in memory
    
    MOVEM.l (SP)+,sub_reg                                       *restore the context
    UNLK A6                                                     *destroy frame pointer
    RTS                                                         *return












    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    PEA vector                                                 *push the vector address in to the stack
    PEA dim                                                    *push the dim address in to the stack
    PEA min                                                    *push the min address in to the stack
    PEA min_index                                              *push the min index address in to the stack
    JSR SEARCHMINIMUM                                          *calls the subroutine
    ADDA.l #16,SP                                              *restore the stack
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
