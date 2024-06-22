*-----------------------------------------------------------
* Title      : 
* Written by : 
* Date       : 
* Description: 
*-----------------------------------------------------------
    ORG   $3000

s1  DC.b 'Hello',0         ; Define string s1 with null-termination
s2  DC.b 'My',0            ; Define string s2 with null-termination
s3  DC.b 'Friend',0        ; Define string s3 with null-termination
ris DS.b 100               ; Reserve 100 bytes for the result buffer
output_off EQU 24          ; Offset for the output length storage
s1_off EQU 20              ; Offset for string 1
s2_off EQU 16              ; Offset for string 2
s3_off EQU 12              ; Offset for string 3
ris_off EQU 8              ; Offset for result buffer
sub_reg REG A0-A3/D0-D3    ; Define the registers used

    ORG   $2000
CONCATENATE:
           LINK A6,#0                 ; Set up the stack frame
           MOVEM.l sub_reg,-(SP)      ; Save used registers on the stack
           MOVEA.l s1_off(A6),A0      ; Load address of s1 into A0
           MOVEA.l s2_off(A6),A1      ; Load address of s2 into A1
           MOVEA.l s3_off(A6),A2      ; Load address of s3 into A2
           MOVEA.l ris_off(A6),A3     ; Load address of the result buffer into A3
           
LOOP1:
           MOVE.b (A0)+,D0            ; Load byte from s1 into D0, increment A0
           CMP.b #0,D0                ; Compare byte with null character
           BEQ LOOP2                  ; If null, go to LOOP2
           ADDQ #1,D3                 ; Increment the length counter D3
           MOVE.b D0,(A3)+            ; Store byte in result buffer, increment A3
           BRA LOOP1                  ; Repeat LOOP1

LOOP2:
           MOVE.b (A1)+,D1            ; Load byte from s2 into D1, increment A1
           CMP.b #0,D1                ; Compare byte with null character
           BEQ LOOP3                  ; If null, go to LOOP3
           ADDQ #1,D3                 ; Increment the length counter D3
           MOVE.b D1,(A3)+            ; Store byte in result buffer, increment A3
           BRA LOOP2                  ; Repeat LOOP2

LOOP3:
           MOVE.b (A2)+,D2            ; Load byte from s3 into D2, increment A2
           MOVE.b D2,(A3)+            ; Store byte in result buffer, increment A3
           ADDQ #1,D3                 ; Increment the length counter D3
           CMP.b  #0,D2               ; Compare byte with null character
           BNE LOOP3                  ; If not null, repeat LOOP3

           SUBQ #1,D3                 ; Adjust length counter for final null byte
           MOVE.b D3,output_off(A6)   ; Store the length of the concatenated string
           MOVEM.l (SP)+,sub_reg      ; Restore saved registers
           UNLK A6                    ; Restore the stack frame
           RTS                        ; Return from subroutine

    ORG    $1000
START:
      ADDA.l #-4,SP              ; Allocate space on the stack for return address
      PEA s1                     ; Push address of s1 onto the stack
      PEA s2                     ; Push address of s2 onto the stack
      PEA s3                     ; Push address of s3 onto the stack
      PEA ris                    ; Push address of result buffer onto the stack
      JSR CONCATENATE            ; Call the CONCATENATE subroutine
      ADDA.l #16,SP              ; Clean up the stack by removing pushed addresses
      MOVE.b (SP),D0             ; Move the first byte of the result into D0 (this might be an error since the stack is cleaned)

    SIMHALT                      ; Halt the simulation

    END    START                 ; End of the program, specifying the start label

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
