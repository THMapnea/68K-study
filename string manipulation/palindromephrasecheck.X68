*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

    ORG  $3000
    
phrase DC.b 'neveroddoreven',0                                                                  *we store in memory our palindrome phrase for simplicity we do not take in consideration blanks
dim DCB.b 1,0                                                                                   *we create space in memory for our output value
sub_reg REG A0-A3/D0-D2                                                                         *registers used by the subroutine
ris_offset EQU      4                                                                           *result offset
phrase_offset EQU   12                                                                          *phrase offset
dim_offset EQU   8                                                                              *dimension offset










    ORG   $2000
    
CHECK LINK A6,#0                                                                                 *create frame pointer
      MOVEM.l sub_reg,-(SP)                                                                      *save context
      MOVEA.l phrase_offset(A6),A0                                                               *load phrase address in A0
      MOVEA.l dim_offset(A6),A1                                                                  *load dimension address in A1
      MOVEA.l ris_offset(A6),A2                                                                  *load result address in A2
      MOVE.b (A0),D0                                                                             *load the first element of the string in A0
DIMENSIONLOOP  CMP.b #0,D0                                                                       *check if we ended the string 
               MOVE.b (A0)+,D0                                                                   *load the next element to check and increment
               BEQ PALINDROMECHECK                                                               *if we terminated the string we see if it is palindrome     
               ADDQ #1,D1                                                                        *increase the dimension 
               MOVE.b D1,(A1)                                                                    *save the dimension
               BRA DIMENSIONLOOP                                                                 *until we finish to loop trough the string I keep incrementing
               

PALINDROMECHECK MOVEA.l phrase_offset(A6),A0                                                     *restore the A0 address to the start in A0
                MOVEA.l A0,A3                                                                    *create a saved point to then go to the end
                MOVE.b (A1),D3                                                                   *load the dimension in D3
                SUBQ #1,D3                                                                       *decrese by one to take consideration of the string end 0
                ADDA.l D3,A3                                                                     *now in A3 it should point to the end
                
PALINDROMELOOP  CMP.b #1,D1                                                                      *check if we looped trough all the string
                BEQ TERMINATE                                                                    *if we did end the program
                MOVE.b (A0)+,D0                                                                  *load first char
                MOVE.b (A3),D2                                                                   *load the element located on the opposite side
                SUBA.l #1,A3                                                                     *decrease A3
                CMP.b  D0,D2                                                                     *check if they are equal
                BEQ EQUAL                                                                        *if they are equal go to equal subroutine  
UNEQUAl MOVE.b #0,(A2)                                                                           *load in to the stack 0        
        BRA TERMINATE                                                                            *if they are not palindrome end the subroutine
EQUAL MOVE.b #1,(A2)                                                                             *load in to the stack 1
      DBRA D1,PALINDROMELOOP                                                                     *decrese D1 go back to testing
      
      
TERMINATE  MOVE.b (A2),D4                                                                        *we save in D4 the bit that tells us if it is palindrome or not           
           MOVEM.l (SP)+,sub_reg                                                                 *restore context
           UNLK A6                                                                               *destroy frame pointer
           RTS                                                                                   *return
    









    ORG    $1000
    
START ADDA.l #-2,SP                                                                               *reserve space for output variable
      PEA phrase                                                                                  *push phrase effective address in to the stack
      PEA dim                                                                                     *push dimension storage address in to the stack
      JSR CHECK                                                                                   *call the subroutine
      ADDA.l #8,SP                                                                               *restore stack pointer 



    SIMHALT             



    END    START        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
