*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------


    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    MOVE.b #3,D0                    *move an immediate value in D0
    MOVE.b #2,D1                    *move another immediate value in D1
    CMP.b D0,D1                     *check wich is the relationship between them
    BEQ EQUAL                       *if they are equal
    BGT GREATER                     *if the second is greater than the first
    BLT LOWER                       *if the second is lower than the first
    BNE NOTEQUAL                    *if they are not equal
    
    EQUAL:
        MOVE.b #0,D2                *save o if they are equal
        BRA TERMINATE               *skip the other labels
        
        
    NOTEQUAL:
        MOVE.b #1,D2                *save 1 if they are not equal
        BRA TERMINATE               *skip the other labels
        
        
    GREATER:
        MOVE.b #2,D2                *save 2 if the destination is bigger than the source
        BRA TERMINATE               *skip the other labels
    
    
    LOWER:
        MOVE.b #3,D2                *save 3 if the destination is lower than the source
        BRA TERMINATE               *skip the other labels


    TERMINATE:
        NOP                         *we jump to this part after one of the possible operation so that we do not go to the other under


    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
