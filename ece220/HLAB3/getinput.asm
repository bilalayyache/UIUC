; getinput.asm
;
; Intoductory Paragraph:
; In this file, it will take the token of the player
; and output the column that the player choose
; If the user's input is not in the range of 1-7, print invalid and ask user to input again


    .ORIG x3400
; GETINPUT
;   Inputs:
;     R0: Current player's token
;   Outputs:
;     R0: Column number chosen by player


; register table
; R0: input current player token
; R0: output column chosen by player
; R1 = -'0'
; R2 = -1
; R3 = -7
; R4 used as a temporary register
GETINPUT
    ; Your code goes here:
    ; do callee-save
    ST R1, GI_SAVER1
    ST R2, GI_SAVER2
    ST R3, GI_SAVER3
    ST R4, GI_SAVER4
    ST R7, GI_SAVER7

    ; code begin here
    LDI R1, GI_ASCII_ZERO                   ; initialize R1 = -'0'
    NOT R1, R1
    ADD R1, R1, #1
    AND R2, R2, #0                          ; initialize R2 = -1
    ADD R2, R2, #-1
    AND R3, R3, #0                          ; initialize R3 = -7
    ADD R3, R3, #-7

GI_BEGIN
    ADD R0, R0, #0                          ; check which player
    BRn GI_PLAYER2
    LD R0, GI_P1_PROMPT                     ; print out prompt for player1
    PUTS
    BR GI_GET_INPUT

GI_PLAYER2
    LD R0, GI_P2_PROMPT                     ; print out prompt for player2
    PUTS

GI_GET_INPUT
    GETC
    OUT
    ADD R0, R0, R1                          ; transfer R0 from ascii to decimal
    ST R0, GI_SAVER0                        ; save the value for R0 in case it is changed after
    ADD R4, R0, R2
    BRn GI_INVALID
    ADD R4, R0, R3
    BRp GI_INVALID
    BR GI_DONE

GI_INVALID
    LDI R0, GI_NEWLINE
    OUT
    LD R0, GI_INVALID_INPUT
    PUTS
    BR GI_BEGIN

GI_DONE
    LDI R0, GI_NEWLINE
    OUT
    LD R0, GI_SAVER0
    LD R1, GI_SAVER1
    LD R2, GI_SAVER2
    LD R3, GI_SAVER3
    LD R4, GI_SAVER4
    LD R7, GI_SAVER7
    RET

GI_SAVER0   .BLKW #1
GI_SAVER1   .BLKW #1
GI_SAVER2   .BLKW #1
GI_SAVER3   .BLKW #1
GI_SAVER4   .BLKW #1
GI_SAVER7   .BLKW #1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Do not modify below this line ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Indirect references to far away locations
GI_ASCII_ZERO
    .FILL x602A
GI_NEWLINE
    .FILL x602B
GI_P1_PROMPT
    .FILL x605A
GI_P2_PROMPT
    .FILL x6072
GI_INVALID_INPUT
    .FILL x608A

; End of assembly file
    .END
