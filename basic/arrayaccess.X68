*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG $2000
    
array DC.b 1,2,3,4,5,6,7,8              *we declare in our memory an array of number
dim EQU 7                               *dimension of our array -1 because we use DBRA









    ORG    $1000
START:                  ; first instruction of program




* Put program code here
    LEA array,A0                       *we load the effective addres of the first element of the array in an address register       
    MOVE.b #dim,D0                     *save the dimension in a data register                 
    LOOP:
        MOVE.b (A0)+,D1                *we move the element saved in the address in a register to see it with post increment 
                                       *so that after we get that we increment the addres and go to the next element
        DBRA D0,LOOP                   *we decrement the count of iteration and loop back

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
