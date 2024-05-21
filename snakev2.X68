*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
EXAMPLESTACK:
    move.l D2,-(sp)                         ;muovo all interno dello stack la posizione iniziale
    add.l #4,sp                             ;aggiungo 4 byte allo stack in modo da scendere giu cosi da trovarmi sotto allo stack resettandolo
    sub #8, sp                              ;sottraggo 8 byte in modo da trovarmi sul rigo che voglio leggere
    move.l (sp),D3                          ;leggo e sposto
    add #8, sp                              ;sottraggo l astessa quantita di byte in modo da essere di nuovo a stack resettato
    
    rts                                     ;return    
      





serpente ds.l 1000
SETCOLOR:
    move.l #41836,D1                        ;muovo l'hex del colore nel registro D1
    move.b #21,D0                           ;passo il comando 21 che setta il fontcolor in D0
    trap #15                                ;chiamo il sistema operativo
                                
    rts                                     ;return
    
    
DRAWCHAR:
    move.b #64,D1                           ;muovo l ascii del carattere nel registro D1
    move.b #6,D0                            ;passo il comando 6 che mostra a schermo un carattere nella posizione del cursore in D0
    trap #15                                ;chiamo il sistema operativo
    
    rts                                     ;return
    


SETCURSOR:
    move.l D2,D1                            ;muovo la posizione del cursore basandomi sulle cordinate di D2
    move.b #11,D0                           ;passo il comando 11 che sposta il cursore 
    trap #15                                ;chiamo il sistema operativo
    
    rts                                     ;return
           
             
UPDATEBODY:
    bsr.b SETCURSOR                         ;imposta il cursore 
    bsr.b DRAWCHAR                          ;disegna il carattere
    rts



DELETECHAR:
    bsr.b SETCURSOR                         ;imposta il cursore
    move.b #32,D1                           ;muove l'ascii del carattere bianco
    move.b #6,D0                            ;passo il comando 6 in D0
    trap #15                                ;chiamo il sistema operativo
    
    rts                                     ;return


WASTETIME:
        move.w #10000,D0                    ;muovo un numero molto grande in D0
        LOOP1: dbf D0,LOOP1                 ;funzione che consuma tempo
        clr D0                              ;ripulisco D0
       
        rts                                 ;return



SLEEP:
       move.b #50,D6                        ;sposto nel registro D6 il numero di iterazioni del loop
       LOOP2: bsr.b WASTETIME               ;nel body del loop chiamo la wastetime
       dbra D6,LOOP2                        ;decremento il loop
       clr D6                               ;ripulisco D6
       
       rts                                  ;return
       
       
_INIT:
    move.b #0, D2                           ;muovo i valori iniziali in D2
    lsl #8, D2                              ;eseguo un logical shift left 00000001 => 00010000
    move.b #0, D2                           ;muovo i valori finali in D2
    bsr.b UPDATEBODY                        ;aggiorno il body
    
    rts                                     ;return


AUTOMOVEMENT:
    MOVEMENTLOOP:                           ;inizializzo il loop
    bsr.b DELETECHAR                        ;cancello il carattere precedente
    add.l D3, D2                            ;aggiungo il valore necessario
    bsr.b UPDATEBODY                        ;aggiorno il body
    bsr.b SLEEP                             ;attendo un po
    bra.l MOVEMENTLOOP                      ;fine del loop solo a programma chiuso
    
    rts                                     ;return


  
  
  
START:                  ; first instruction of program

* Put program code here
    bsr.l SETCOLOR                          ;setto il fontcolor
    bsr.b _INIT                             ;inizializzo
    move.l #256,D3
    bsr.b AUTOMOVEMENT                      ;faccio iniziare l automovimento
    
    

    
    
    
    















    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
