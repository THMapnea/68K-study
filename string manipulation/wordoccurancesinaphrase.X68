*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG $3000
    
phrase DC.b 'ciao mamma non preoccuparti sono in val di siusa',0      *declaration of a space of memory containing a null terminated string
word DC.b 'c'                                                         *declaration of the word to search
occurances DS.b 1                                                     *space of memory in wich we save the occurances of the word
sub_reg REG A0-A2/D0-D3                                               *declaration of the register used in the subroutine with then context saving
phrase_offset EQU 16                                                  *phrase offset
word_offset EQU 12                                                    *word offset
occurances_offset EQU 8                                               *occurances offset




    ORG $2000
    
INCREMENT:
    ADDQ #1,D3                                                        *increase the value of D3 if the char is found
    BRA TEST                                                          *after we check if the string ended

SEARCHWORDOCCURANCES:
    LINK A6,#0                                                        *creation of the frame pointer
    MOVEM.l sub_reg,-(SP)                                             *context creation                                         
    MOVEA.l phrase_offset(A6),A0                                      *saving tha addres of the phrase from stack to address register
    MOVEA.l word_offset(A6),A1                                        *saving tha addres of the word from stack to address register 
    MOVEA.l occurances_offset(A6),A2                                  *saving tha addres of the occurances from stack to address register
    MOVE.b (A1),D1                                                    *move the search carachter in a data register
    CLR D3
    
    LOOP:
        MOVE.b (A0)+,D0                                               *access the element of the string and post increment to got to the next 
        CMP.b D1,D0                                                   *check if the two characters are equal
        BEQ INCREMENT                                                 *if they are equal increments the occurances saved in D3
    TEST:    CMP.b #0,D0                                              *check if we found the end of the string
        BNE LOOP                                                      *if we haven't we branch back to the loop
    
    
    MOVE.b D3,(A2)                                                    *save the result in memory
    MOVEM.l (SP)+,sub_reg                                             *restore context
    UNLK A6                                                           *frame pointer destruction
    RTS                                                               *return







    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    PEA phrase                                                        *push the effective addres in the stack
    PEA word                                                          *push the effective addres in the stack
    PEA occurances                                                    *push the effective addres in the stack
    JSR SEARCHWORDOCCURANCES                                          *calls the subroutine
    ADDA.l #12,SP                                                     *restore the stack pointer

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
