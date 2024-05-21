*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    *D2 contiene la posizione del player
    *D3 dovra contenere la posizione del cursore
    *D4 deve contenere la posizione precedente del player
    *D5 viene mandato il valore dove settare il cursore
    *implementare salvataggio e presa da e in memoria dei colori


    ORG    $1000

                

SET_COLOR:
    MOVE.l #41836,D1                        *muovo l'hex del colore nel registro D1
    MOVE.b #21,D0                           *passo il comando 21 che setta il fontcolor in D0
    TRAP #15                                *chiamo il sistema operativo
    CLR D1                                  *pulisco D1
                                
    RTS                                     *return   


REMOVE_KEYBOARD_ECHO:
    MOVE.b #0,D1                            *sposto il valore 0 in D1.b per rimuovere l'echo
    MOVE.b #12,D0                           *carico in D0 il valore 12 per settare l echo
    TRAP #15                                *chiamo il sistema operativo
    CLR D1                                  *svuoto D1
    
    RTS                                     *return


CLEAR_SCREEN:
    MOVE.b #11,D0                           *passo il comando 11 per scrivere
    MOVE.w $FF00,D1                         *passo il carattere di pulizia dello schermo
    TRAP #15                                *chiamo il sistema operativo
    CLR D1                                  *ripulisco D1
    
    RTS                                     *return


RESET_CURSOR:
    MOVE.b #11,D0                           *sposto il valore 11 in D0 per spostare il cursore
    CLR D1                                  *svuoto D1 in modo che il valore passato per lo spostamento corrisponda a (0,0)
    TRAP #15                                *chiamo il sistema operativo
    
    RTS                                     *return


SET_CURSOR:
    MOVE.b #11,D0                           *passo il valore 11 per settare il cursore
    MOVE.l D5,D1                            *passo il valore della posizione al cursore
    TRAP #15                                *chiamo il sistema operativo

    
    RTS                                     *return


SHOW_PLAYER:
    MOVE.b #64,D1                           *muovo l ascii del carattere nel registro D1
    MOVE.b #6,D0                            *passo il comando 6 che mostra a schermo un carattere nella posizione del cursore in D0
    TRAP #15                                *chiamo il sistema operativo
    CLR D1                                  *ripulisco D1
    
    RTS                                     *return


DELETE_PLAYER:
    MOVE.b D4,D5                            *passo la posizione precedente al registro che si occupa del cursore
    JSR SET_CURSOR                          *posiziono il cursore
    MOVE.b #6,D0                            *passo il valore 6 per scrivere
    MOVE.b #32,D1                           *passo il carattere blank in D1 con ascii 32
    TRAP #15                                *chiamo il sistema operativo
    
    RTS                                     *return


CREATE_PLAYER:
    JSR RESET_CURSOR                        *imposto il cursore nella posizione di partenza
    MOVE.b #0,D2                            *setto 0000 cioe (0,0) come coordinate iniziali
    LSL.b #8, D2                            *effettuo lo shift sinistro della posizione
    MOVE.b #0,D2                            *setto     0000 cioe (0,0) come coordinate iniziali
    ADD.l #257,D2                           *aggiungo 257 per muoverlo di uno a sinistra e di uno in basso per evitare l overlapping con i bordi
    MOVE.l D2,D3                            *aggiorno la posizione del cursore con le coordinate iniziali
    MOVE.l D3,D5                            *sposto la posizione del cursore nel registro D5 che si occupa della gestione del cursore
    JSR SET_CURSOR                          *sposto il cursore alla nuova posizione
    JSR SHOW_PLAYER                         *mostro il carattere caricandolo nella posizione del cursore
    MOVE.b #1,D3                            *passo la posizione del cursore
    MOVE.b #0,D4                            *passo la posizione precedente del player
    
    RTS                                     *return


DRAW_BOUNDARY:
    JSR SET_CURSOR                          *setto il cursore
    MOVE.l D7,D1                           *carico il carattere > nel registro D1
    MOVE.l #6,D0                            *sposto il valore 6 in D0
    TRAP #15                                *chiamo il sistema operativo

    RTS                                     *return


CREATE_BOUNDARY:
    MOVE.l #0,D5                            *carico la posizione iniziale del cursore
    MOVE.l #0,D6                            *carico a 0 il counter
    MOVE.l #62,D7                           *passo il carattere > in D7 per mostrarlo
    JSR SET_CURSOR                          *setto il cursore
    JSR DRAW_BOUNDARY                       *disegno il primo bordo
    
    BOUNDARY_LOOP_DOWN1:
        JSR DRAW_BOUNDARY                   *disegno il boundary alla posizione del cursore !!!! deve andare prima dell incremento poiche SET_CURSOR cambia il valore di Z
        ADDQ #1,D6                          *incremento il counter poiche il primo e disegnato all inizio
        ADD.l #1,D5                         *scendo in basso di 1
        CMP #32,D6                          *controllo se ha fatto tutte e 31 le iterazioni
        BNE BOUNDARY_LOOP_DOWN1              *continuo il loop se non ho fatto tutte le iterazioni  
    CLR D6                                  *pulisco D6 per azzerare il counter
    CLR D5                                  *pulisco D5 per ritornare sopra
    MOVE.l #43,D7                           *passo il carattere  in D7 per mostrarlo
    
    BOUNDARY_LOOP_RIGHT:
        JSR DRAW_BOUNDARY                   *disegno il boundary alla posizione del cursore !!!! deve andare prima dell incremento poiche SET_CURSOR cambia il valore di Z
        ADD #1,D6                           *incremento il counter poiche il primo e disegnato all inizio
        ADD.l #256,D5                       *vado a destra di 1 aggiungendo 256
        CMP #80,D6                          *controllo se ha fatto tutte e 80 le iterazioni
        BNE BOUNDARY_LOOP_RIGHT             *continuo il loop se non ho fatto tutte le iterazioni    
    CLR D6                                  *pulisco D6 per azzerare il counter
    CLR D5                                  *ripulisco D5
    ADD.l #31,D5                            *aggiungo 31 a D5 in modo da spostarmi in basso
    
    BOUNDARY_LOOP_LEFT:
        JSR DRAW_BOUNDARY                   *disegno il boundary alla posizione del cursore !!!! deve andare prima dell incremento poiche SET_CURSOR cambia il valore di Z
        ADD #1,D6                           *incremento il counter poiche il primo e disegnato all inizio
        ADD.l #256,D5                       *vado a destra di 1 aggiungendo 256
        CMP #80,D6                          *controllo se ha fatto tutte e 80 le iterazioni
        BNE BOUNDARY_LOOP_LEFT              *continuo il loop se non ho fatto tutte le iterazioni    
    CLR D6                                  *pulisco D6 per azzerare il counter
    CLR D5                                  *ripulisco D5 
    MOVE.l #60,D7                           *muovo il simbolo < in D7
    MOVE.l #$4F00,D5                        *Sposto 256 per 80 in D5 in modo da mettermi alla fine
     
    BOUNDARY_LOOP_DOWN2:
        JSR DRAW_BOUNDARY                   *disegno il boundary alla posizione del cursore !!!! deve andare prima dell incremento poiche SET_CURSOR cambia il valore di Z
        ADDQ #1,D6                          *incremento il counter poiche il primo e disegnato all inizio
        ADD.l #1,D5                         *scendo in basso di 1
        CMP #32,D6                          *controllo se ha fatto tutte e 31 le iterazioni
        BNE BOUNDARY_LOOP_DOWN2             *continuo il loop se non ho fatto tutte le iterazioni  
    CLR D6                                  *pulisco D6 per azzerare il counter
    CLR D5                                  *pulisco D5 per ritornare sopra 
   


        
    CLR D7                                  *pulisco il registro per successivi usi
    RTS                                     *return


RIGHT:
    MOVE.l D2,D4                            *saalvo la posizione precedente in D4
    JSR DELETE_PLAYER                       *cancello il player
    ADD.l #256,D2                           *aggiungo 256 per spostarlo a destra di 1 casella

    
    RTS                                     *return


LEFT:
    MOVE.l D2,D4                            *saalvo la posizione precedente in D4
    JSR DELETE_PLAYER                       *cancello il player
    SUB.l #256,D2                           *sottraggo 256 per spostarlo a sinistra di 1 casella
    
    RTS                                     *return


DOWN:
    MOVE.l D2,D4                            *saalvo la posizione precedente in D4
    JSR DELETE_PLAYER                       *cancello il player
    ADD.l #1,D2                             *aggiungo 1 per spostarlo verso il basso di 1 casella
    
    RTS                                     *return

UP:
    MOVE.l D2,D4                            *saalvo la posizione precedente in D4
    JSR DELETE_PLAYER                       *cancello il player
    SUB.l #1,D2                             *sottraggo 1 per spostarlo verso l alto di 1 casella
    
    RTS                                     *return


GET_INPUT:
    MOVE.b #5,D0                            *sposto il valore 5 in D0 per prendere un valore da tastiera
    TRAP #15                                *chiamo il sistema operativo
    CMP #100,D1                             *vedo se ho premuto d in ascii decimale 100
    BEQ RIGHT                               *se e vero vado a destra
    CMP #97,D1                              *vedo se ho premuto a in ascii decimale 97
    BEQ LEFT                                *se si vado a sinistra
    CMP #115,D1                             *vedo se ho premuto s in ascii decimale 115
    BEQ DOWN                                *se si vado giu
    CMP #119,D1                             *vedo se ho premuto w in ascci decimale 119
    BEQ UP                                  *se si vado su
    
    RTS                                     *return



END_GAME:
    MOVE.b #9,D0                           *passo il comando 9 che termina il programma in D0
    TRAP #15                               *chiamo il sistema operativo

    RTS                                    *return



CHECK_COLLISION:
    MOVE.b #22,D0                          *passo il valore 22 per leggere da schermo un carattere presente
    MOVE.l D2,D1                           *sposto i valori di D2 in D1 per passare al comando 22 la posizione del cursore
    TRAP #15                               *chiamo il sistema operativo
    CMP #$2E,D1                            *verifico se il carattere preso corrisponde con quello presente sul terminale che e dato da ASCII diversa
    BEQ END_GAME                           *se e uguale termino il gioco
    CMP #$2B,D1                            *verifico se il carattere preso corrisponde con quello presente
    BEQ END_GAME                           *se e uguale termino il gioco

    
    RTS                                    *return





   
    
START:                  ; first instruction of program

* Put program code here
    JSR SET_COLOR                          *imposto il colore dei caratteri 
    JSR REMOVE_KEYBOARD_ECHO               *rimuovo l'echo della tastiera
    JSR CREATE_BOUNDARY                    *creo i limiti della mappa                  
    JSR CREATE_PLAYER                      *creo il player
    MOVEMENT_LOOP:
        JSR GET_INPUT                      *prendo l'input
        MOVE.l D2,D5                       *passo al registro del cursore la posizione dove stampare il player
        JSR SET_CURSOR                     *setto il cursore
        JSR CHECK_COLLISION                *controllo per le collisioni
        JSR SHOW_PLAYER                    *mostro il player
        CMP #48,D1                         *controllo se e stato cliccato 0
        BNE MOVEMENT_LOOP                  *se non e stato cliccato 0 richiedo di nuovo l input

                     


    
    

    

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
