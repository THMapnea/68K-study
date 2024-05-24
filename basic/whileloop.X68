*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    MOVE.b #0,D0                    *save our number in D0 
    
    LOOP:                           *declare our label that contain our loop logic 
        ADDQ.b #2,D0                *increment it by one
        CMP.b #16,D0                *check if we reached the condition
        BNE LOOP                    *if we haven't go back 
    
    
    
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
