; updateboard.asm
;
; Intoductory Paragraph:
; In this file, it will get the player's input and give response to this input
; If input successfully,

    .ORIG x3800
; UPDATEBOARD
;   Inputs:
;     R0: Current player's token. 1 for player 1 and -1 for player 2.
;     R1: Column to make move in [1-7]
;   Outputs:
;     R0: Memory location that is updated if successful
;         0 if move was unsuccessful (column is full)

; register table
; R0: input current player and output if the move is success
; R0: output the memory location that is updated or 0 which stands for unsuccessful move
; R1: input column to make move in
; R2 = 7
; R6 = -7
; R5 = 6, as a row counter
; R3: memory pointer
; R4: get the value stored in memory location R3


UPDATEBOARD
    ; Your code goes here:
    ; do callee-save first
    ST R1, UB_SAVER1
    ST R2, UB_SAVER2
    ST R3, UB_SAVER3
    ST R4, UB_SAVER4
    ST R5, UB_SAVER5
    ST R6, UB_SAVER6
    ST R7, UB_SAVER7

    ; code begin here
    AND R2, R2, #0                        ; initialize R2 = 7, R5 = 6, R6 = -7
    ADD R2, R2, #7
    NOT R6, R2
    ADD R6, R6, #1
    AND R5, R5, #0
    ADD R5, R5, #6
    ; first, to check if column is full
    LD R3, UB_BOARD                       ; find the location that player wants to put disc
    ADD R3, R3, #-1
    ADD R3, R3, R1
    LDR R4, R3, #0                        ; find the value of this location
    BRnp FAIL                             ; if the value is not 0, this column has already full

UB_NEXT_ROW                               ; begin to place this disc and change the memory
    ADD R5, R5, #0                        ; check whether this is the bottom row
    BRz UB_BOTTOM_ROW
    ADD R5, R5, #-1
    ADD R3, R3, R2                        ; go to next row but same column
    LDR R4, R3, #0
    BRz UB_NEXT_ROW
    ADD R3, R3, R6
UB_BOTTOM_ROW
    STR R0, R3, #0                        ; store the value of R0 in memory location R3
    ADD R0, R3, #0                        ; return the memory location of the last move
    BR DONE_UB

FAIL
    AND R0, R0, #0

DONE_UB
    LD R1, UB_SAVER1
    LD R2, UB_SAVER2
    LD R3, UB_SAVER3
    LD R4, UB_SAVER4
    LD R5, UB_SAVER5
    LD R6, UB_SAVER6
    LD R7, UB_SAVER7


    RET

UB_SAVER1 .BLKW #1
UB_SAVER2 .BLKW #1
UB_SAVER3 .BLKW #1
UB_SAVER4 .BLKW #1
UB_SAVER5 .BLKW #1
UB_SAVER6 .BLKW #1
UB_SAVER7 .BLKW #1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Do not modify below this line ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Indirect references to far away locations
UB_BOARD
    .FILL x6000

; End of assembly file
    .END
