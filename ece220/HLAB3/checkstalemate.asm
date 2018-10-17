; checkstalemate.asm
;
; Intoductory Paragraph:
; In this file, it will check whether there is any space for disc
; If the board is full, output R0 should be 1
; If the board has empty spot, output R0 should be 0
;


    .ORIG x3C00
; CHECKSTALEMATE
;   Outputs:
;     R0: 1 if the board is filled
;         0 if it isn't

; register table
; R3: memory pointer
; R4: value stored in memory location R3
; R1 = 7, is a column counter
; R0 is the output of this subroutine

CHECKSTALEMATE
    ; Your code goes here:
    ; first do callee-save
    ST R1, CS_SAVER1
    ST R3, CS_SAVER3
    ST R4, CS_SAVER4
    ST R7, CS_SAVER7

    ; code begin here
    AND R1, R1, #0                      ; initialize R1 = 7
    ADD R1, R1, #7
    LD R3, CS_BOARD                     ; initialize memory location

CS_NEXT_CHAR
    LDR R4, R3, #0
    BRz CS_NOT_FULL                     ; if the value is 0, the board is not full
    ADD R3, R3, #1                      ; go to next location
    ADD R1, R1, #-1
    BRp CS_NEXT_CHAR
    AND R0, R0, #0                      ; the board is full, set R0 = 1
    ADD R0, R0, #1
    BR CS_DONE

CS_NOT_FULL
    AND R0, R0, #0                      ; the board is not full, set R0 = 0
CS_DONE
    LD R1, CS_SAVER1
    LD R3, CS_SAVER3
    LD R4, CS_SAVER4
    LD R7, CS_SAVER7

    RET

CS_SAVER1   .BLKW #1
CS_SAVER3   .BLKW #1
CS_SAVER4   .BLKW #1
CS_SAVER7   .BLKW #1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Do not modify below this line ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Indirect references to far away locations
CS_BOARD
    .FILL x6000

; End of assembly file
    .END
