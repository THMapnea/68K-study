*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

    ORG     $3000

phrase1 DC.b 'screw you guys',0                         *declare the first phrase
phrase2 DC.b 'I am going home',0                        *declare the second phrase
result DS.b 1000                                        *save memory for the concatenation with worst case scenario
sub_reg REG A0-A2/D0-D2                                 *save the register called by subroutines
phrase1_offset EQU 16                                   *phrase 1 offset
phrase2_offset EQU 12                                   *phrase 2 offset
result_offset EQU 8                                     *result offset


    ORG     $2000

CONCATENATE:
    LINK A6,#0                                          *create the frame pointer
    MOVEM.l sub_reg,-(SP)                               *save context
    MOVEA.l phrase1_offset(A6),A0                       *load from stack the addres of first element of phrase 1
    MOVEA.l phrase2_offset(A6),A1                       *load from stack the addres of first element of phrase 2
    MOVEA.l result_offset(A6),A2                        *load from stack the addres of first element of result
    
    
    FIRSTLOOP:
        MOVE.b (A0)+,D0                                 *load theelement in data register with post increment
        CMP.b #0,D0                                     *check if the string is ended
        BEQ SECONDLOOP                                  *if its ended go to the second one
        MOVE.b D0,(A2)+                                 *save in memory the char from first string                              
        BNE FIRSTLOOP                                   *if not branch to first loop
    
    
    SECONDLOOP:
        MOVE.b (A1)+,D1                                 *load the element in data register with post increment
        MOVE.b D1,(A2)+                                 *save in memory the char from second string after the first string
        CMP.b #0,D1                                     *check if the string is ended
        BNE SECONDLOOP                                  *if not branch back to second loop

    
    MOVEM.l (SP)+,sub_reg                               *context reload
    UNLK A6                                             *frame pointer destruction
    RTS                                                 *return










    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    PEA phrase1                                         *push the addres of phrase 1 on to the stack
    PEA phrase2                                         *push the addres of phrase 2 on to the stack
    PEA result                                          *push the addres of result on to the stack
    JSR CONCATENATE                                     *subroutine call
    ADDA.l #12,SP                                       *restore the stack
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
