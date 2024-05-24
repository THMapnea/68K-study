*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    MOVE.b #10,D0                   *we initialize the counter
    SUBQ.b #1,D0                    *to make it easy we will use DBRA so we decrement the number of iteration by one because DBRA ends when ==-1 or if you look at it in HEX ==FF
    
    LOOP:                           *create the label where we deploy the instruction to loop trough
        ADDQ.b #1,D1                *to see it working we can add quick one to a register to keep count of the iteration if you want you can remove this line and implement your own logic
        DBRA D0,LOOP                *decrease the counter and go to the head if counter hasn't reached -1 
    
    
    
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
