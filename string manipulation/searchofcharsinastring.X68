*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG $3000
string DC.b 'to be or not to be that is the question',0                               *string where we want to search the chars
chars DC.b 'tox',0                                                                    *set of chars to recognize
result DCB.b 3,0                                                                      *array to set as high if char found
sub_reg REG A0-A2/D0-D1                                                               *register used in the subroutine 
string_offset EQU 16                                                                  *offset of the string address in the stack
chars_offset  EQU 12                                                                  *offset of the chars in the stack
result_offset EQU 8                                                                   *offset of the result address in the stack




    ORG    $2000
SEARCH:
    LINK A6,#0                                                                         *create the framepointer
    MOVEM.l sub_reg,-(SP)                                                              *save the context
    MOVEA.l string_offset(A6),A0                                                       *load in A0 the string address
    MOVEA.l chars_offset(A6),A1                                                        *load in A1 the chars address
    MOVEA.l result_offset(A6),A2                                                       *load in A2 the result address
    MOVE.b (A1),D1                                                                     *load first element to check if the array is null on the first iteration
    MOVE.b (A0),D0                                                                     *load first element to check if the array is null on the first iteration
    
    CHARSLOOP:
        CMP.b #0,D1                                                                    *see if we looked trough all the char
        BEQ   TERMINATE                                                                *if we did we terminate
        MOVE.b (A1)+,D1                                                                *load the first char to search and increment so that on the next iteration we go to the next char to search
        STRINGLOOP:
            CMP.b #0,D0                                                                *check if we looked trough all the string
            BEQ CHARSLOOP                                                              *if we did we go to the next char
            MOVE.b (A0)+,D0                                                            *load element of the array with post increment 
            CMP.b D0,D1                                                                *check if we found the char
            BEQ UPDATE                                                                 *if we did we update the value in the result array
            BNE STRINGLOOP                                                             *otherwise we check again on the next element
    UPDATE:
        MOVE.b #1,(A2)+                                                                *we set at one the vale of the found element
        MOVE.l string_offset(A6),A0                                                    *reset the string counter so that we check from the start again
        BRA CHARSLOOP                                                                  *branch back to charsloop because we dont need to check because we already found the char
    TERMINATE: nop                                                                     *if we arrive here we looped trough all the chars so we can terminate the subroutine
    MOVEM.l (SP)+,sub_reg                                                              *restore the context
    UNLK A6                                                                            *destroy the framepointer 
    RTS                                                                                *return










    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    PEA string                                                                        *push the effective address of the string in the stack
    PEA chars                                                                         *push the effective address of the chars in the stack
    PEA result                                                                        *push the effective address of the result in the stack
    JSR SEARCH                                                                        *calls the subroutine
    ADDA.l #12,SP                                                                     *restore the stack pointer
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
