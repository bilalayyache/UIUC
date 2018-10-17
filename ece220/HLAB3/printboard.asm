; printboard.asm
;
; Intoductory Paragraph:
; In this file, it will read the memory location from x6000 to x6029
; If the value is 0, it means that this spot is not occupied yet and we need to print '0' here
; If the value is 1, it means this spot is occupied by player1 and we need to print 'X' here
; If the value is -1, it means this spot is occupied by player2 and we need to print 'O' here

    .ORIG x3600
; PRINTBOARD
; register table
; R0: output the char represent the occupation of the board
; R1: row pointer
; R2: column pointer
; R3: memory pointer
; R4: get the value stored in memory location R3
PRINTBOARD
    ; Your code goes here:
    ; do callee-save
    ST R0, PRINTBOARD_SAVER0
    ST R1, PRINTBOARD_SAVER1
    ST R2, PRINTBOARD_SAVER2
    ST R3, PRINTBOARD_SAVER3
    ST R4, PRINTBOARD_SAVER4
    ST R7, PRINTBOARD_SAVER7

    ; code begin here
    AND R1, R1, #0                        ;initialize R1, R2, R3
    ADD R1, R1, #6
    AND R2, R2, #0
    ADD R2, R2, #7
    LD R3, PB_BOARD


PB_NEXT_CHAR                              ; next row
    LDR R4, R3, #0                        ; load current value
    BRn PB_PLAYER2                        ; if the value is negative, print 'O' for player2
    ADD R4, R4, #0
    BRp PB_PLAYER1                        ; if the value is positive, print 'X' for player1
    LDI R0, PB_EMPTY_PIECE
    OUT
    BR FINISH_ONECHAR

PB_PLAYER1
    LDI R0, PB_P1_PIECE
    OUT
    BR FINISH_ONECHAR

PB_PLAYER2
    LDI R0, PB_P2_PIECE
    OUT

FINISH_ONECHAR
    ADD R3, R3, #1                        ; go to the next memory location
    ADD R2, R2, #-1                       ; decrease R2 by 1
    BRz PB_NEXT_ROW                       ; finish printing one row
    BR PB_NEXT_CHAR

PB_NEXT_ROW
    ADD R2, R2, #7                        ; recover R2 and get ready for the next row
    ADD R1, R1, #-1                       ; check if finish printing all rows
    BRz COMPLETE_BOARD
    LDI R0, PB_NEWLINE
    OUT
    BR PB_NEXT_CHAR

COMPLETE_BOARD
    LDI R0, PB_NEWLINE
    OUT
    LD R0, PRINTBOARD_SAVER0
    LD R1, PRINTBOARD_SAVER1
    LD R2, PRINTBOARD_SAVER2
    LD R3, PRINTBOARD_SAVER3
    LD R4, PRINTBOARD_SAVER4
    LD R7, PRINTBOARD_SAVER7

    RET

PRINTBOARD_SAVER0
    .BLKW #1
PRINTBOARD_SAVER1
    .BLKW #1
PRINTBOARD_SAVER2
    .BLKW #1
PRINTBOARD_SAVER3
    .BLKW #1
PRINTBOARD_SAVER4
    .BLKW #1
PRINTBOARD_SAVER7
   .BLKW #1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Do not modify below this line ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Indirect references to far away locations
PB_BOARD
    .FILL x6000
PB_ASCII_ZERO
    .FILL x602A
PB_NEWLINE
    .FILL x602B
PB_EMPTY_PIECE
    .FILL x602C
PB_P1_PIECE
    .FILL x602D
PB_P2_PIECE
    .FILL x602E

; End of assembly file
    .END
