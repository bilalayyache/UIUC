; checkforwin.asm
;
; Intoductory Paragraph:
; In this file, it takes the input of current player's token, column of last move
; and memory location in the last move
; Output would be whether the game is over. If R0 = 1, someone wins.
;

    .ORIG x3A00
; CHECKFORWIN
;   Inputs:
;     R0: Current player's token
;     R1: Column of last move
;     R2: Memory location modified in last move
;   Outputs:
;     R0: 1 if the player wins
;         0 if no win

; register table
; R0: input player's token and output the result of the check
; R1: input column player has chosen
; R2: input memory location of last move
; R3: hold the sum of consecutive four spots on the board (horizontal, vertical, diagonal)
; R4: temporary register used to indicate the current memory location
; R5: store the value in memory location which is being manipulating
; R6: output of subroutine CW_CHECK, to check whether a value is 4 or -4
CHECKFORWIN
    ; Your code goes here:
    ; first do callee-save
    ST R1, CW_SAVER1
    ST R2, CW_SAVER2
    ST R3, CW_SAVER3
    ST R4, CW_SAVER4
    ST R5, CW_SAVER5
    ST R6, CW_SAVER6
    ST R7, CW_SAVER7

    ; code begins here
    ; first do column check
    AND R3, R3, #0                    ; initialize R3
    LD R4, CW_6014
    NOT R4, R4
    ADD R4, R4, #1                    ; let R4 = -x6014 to check whether the input memory location
                                      ; is above row four
    ADD R4, R4, R2
    BRp CW_ROWCHECK
    ; begin to sum four spots in column
    LDR R5, R2, #0
    ADD R3, R3, R5                    ; add the first number
    ADD R4, R2, #7
    LDR R5, R4, #0
    ADD R3, R3, R5                    ; add the second number
    ADD R4, R4, #7
    LDR R5, R4, #0
    ADD R3, R3, R5                    ; add the third number
    ADD R4, R4, #7
    LDR R5, R4, #0
    ADD R3, R3, R5                    ; add the fourth number
    JSR CW_CHECK
    ADD R6, R6, #0
    BRp CW_WIN

                                      ; if no one get 4 discs in a column, go to row check
CW_ROWCHECK
    AND R3, R3, #0                    ; initialize R3
    NOT R1, R1
    ADD R1, R1, #1                    ; R1 = -R1 to find the first memory location in this row
    ADD R4, R2, R1                    ; now R4 is the first memory location of this row
    AND R1, R1, #0
    ADD R1, R1, #4                    ; change R1 = 4, as a row counter (finally R1 will be recovered)
CW_NEXT_CHECK
    ADD R4, R4, #1
    LDR R5, R4, #0
    ADD R3, R3, R5                    ; add the first value
    ADD R4, R4, #1
    LDR R5, R4, #0
    ADD R3, R3, R5                    ; add the second value
    ADD R4, R4, #1
    LDR R5, R4, #0
    ADD R3, R3, R5                    ; add the third value
    ADD R4, R4, #1
    LDR R5, R4, #0
    ADD R3, R3, R5                    ; add the last value
    JSR CW_CHECK
    ADD R6, R6, #0
    BRp CW_WIN
    ADD R4, R4, #-3
    ADD R1, R1, #-1
    BRp CW_NEXT_CHECK

                                      ; if no one get 4 discs in a row, go to diagonal check
CW_DIAGCHECK
    AND R3, R3, #0                    ; initialize R3
    LD R1, CW_SAVER1                  ; recover R1
    BR CW_NOT_WIN


CW_WIN
    AND R0, R0, #0
    ADD R0, R0, #1
    BR CW_DONE

CW_NOT_WIN
    AND R0, R0, #0
CW_DONE
    LD R1, CW_SAVER1
    LD R2, CW_SAVER2
    LD R3, CW_SAVER3
    LD R4, CW_SAVER4
    LD R5, CW_SAVER5
    LD R6, CW_SAVER6
    LD R7, CW_SAVER7
    RET

CW_SAVER1  .BLKW #1
CW_SAVER2  .BLKW #1
CW_SAVER3  .BLKW #1
CW_SAVER4  .BLKW #1
CW_SAVER5  .BLKW #1
CW_SAVER6  .BLKW #1
CW_SAVER7  .BLKW #1

CW_6014
    .FILL x6014                       ; this is the last memory location of the third row

CW_CHECK
; this is a subroutine that check whether the input is 4 or -4
; input R3
; output R6 = 1 if R3 = 4 or -4
; output R6 = 0 is R3 is not 4 and -4
    ST R3, CW_CHECK_SAVER3
    AND R6, R6, #0
    ADD R3, R3, #-4
    BRz CW_CHECK_WIN
    ADD R3, R3, #8
    BRz CW_CHECK_WIN
    BR CW_CHECK_DONE

CW_CHECK_WIN
    ADD R6, R6, #1
CW_CHECK_DONE
    LD R3, CW_CHECK_SAVER3
    RET

CW_CHECK_SAVER3
    .BLKW #1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Do not modify below this line ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Indirect references to far away locations
CW_BOARD
    .FILL x6000

; End of assembly file
    .END
