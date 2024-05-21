*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG $2000
esponente DC.b 5
base DC.b 2
risultato DS.l 1
sub_reg REG A0-A2/D0-D3


    ORG 1200
CALCOLOFATTORIALE:
    LINK A6,#0
    MOVEM.l sub_reg,-(SP)
    MOVEA.l 16(A6),A0
    MOVEA.l 12(A6),A1
    MOVEA.l  8(A6),A2
    MOVE.b  (A0),D0
    MOVE.b  (A1),D1
    SUBQ #1,D0
    MOVE.b D1,D3
    CALCOLA:
        MULS D1,D3
        DBRA D0,CALCOLA
    MOVE.l D3,(A2)

    MOVEM.l (SP)+,sub_reg
    UNLK A6
    RTS





    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    PEA esponente
    PEA base
    PEA risultato
    JSR CALCOLOFATTORIALE
    ADDA.l #12,SP
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
