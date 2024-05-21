*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG   $3000
    
vect1 DC.w 1,2,3,4,5,6                      *declare vector 1
vect2 DC.w 3,4,5,6,7,8                      *declare vector 2
dim DC.b 5                                  *dimension of vectors
ris DS.l 1                                  *result we are considering not using I/O operation to get values
vect1_offset EQU 20                         *we create a constant with the offset in the stack of our vector 1 that given the lifo structure needs to be the higher
vect2_offset EQU 16                         *we create a constant with the offset in the stack of our vector 2
dim_offset EQU 12                           *we create a constant with the offset in the stack of our dim
ris_offset EQU 8                            *we create a constant with the offset in the stack of our dim
sub_reg REG A0-A3/D0-D3                     *we create a list of register that we will later save and load during our subroutine



    ORG    $2000
    
COMPUTEPRODUCT:
    LINK A6,#0                              *we link/create our frame pointer with no offset
    MOVEM.l sub_reg,-(SP)                   *make a context save 
    
    MOVEA.l vect1_offset(A6),A0             *load from the stack in to an address register
    MOVEA.l vect2_offset(A6),A1             *load from the stack in to an address register
    MOVEA.l dim_offset(A6),A2               *load from the stack in to an address register
    MOVEA.l ris_offset(A6),A3               *load from the stack in to an address register the addres of the storage memory that we declared previously
    MOVE.b (A2)+,D2                         *we load the dimension in a data register
    CLR D3                                  *we clear D3 to be sure to have no value before starting operating
    
    LOOP:
        MOVE.w (A0)+,D0                     *we load the value of the element of the array in a data register with post increment because we are looping trough the array
        MOVE.w (A1)+,D1                     *we load the value of the element of the array in a data register with post increment because we are looping trough the array
        MULS D0,D1                          *we multiply the two vectors
        ADD.l D1,D3                         *we sum the value to the precedent sum
        DBRA D2,LOOP                        *we see if we looped trough all the array  remembering that DBRA stops at -1 dimensionmust be set as arraydimension -1 
    MOVE.l D3,(A3)                          *we save the result in the memory space once it has looped trough all the arrays
    
    MOVEM.l (SP)+,sub_reg                   *we restore our context
    UNLK A6                                 *we destroy our frame pointer since he has fulfilled  his purpose
    RTS                                     *return




    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    PEA vect1                               *push in the stack vector1 effective address
    PEA vect2                               *push in the stack vector2 effective address
    PEA dim                                 *push in the stack dim effective address
    PEA ris                                 *push in the stack result vector effective address
    JSR COMPUTEPRODUCT                      *subroutine call to execute the scalar product
    ADDA.l #16,SP                           *reset of the stack pointer after the subroutine call
    
    
    
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
