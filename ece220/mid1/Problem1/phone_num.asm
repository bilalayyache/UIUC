.ORIG x3000

;your program starts here
        AND R5, R5, #0          ; R5 is a flag
        AND R6, R6, #0
        ADD R6, R6, #11

START   LDI R1, KBSR
        BRzp START
        LDI R0, KBDR
ECHO    LDI R1, DSR
        BRzp ECHO
        STI R0, DDR
        ADD R6, R6, #-1
        LD R2, NEWLINE
        NOT R2, R2
        ADD R2, R2, #1
        ADD R2, R2, R0
        BRz DONE_INPUT
        ADD R5, R5, #0
        BRp START
        JSR CHECK
        BR START

CHECK   LD R3, ASCII_0
        NOT R3, R3
        ADD R3, R3, #1
        ADD R3, R3, R0
        BRn NOT_NUMBER
        LD R4, ASCII_9
        NOT R4, R4
        ADD R4, R4, #1
        ADD R4, R4, R0
        BRp NOT_NUMBER
        BR DONE_CHECK
NOT_NUMBER
        ADD R5, R5, #1
DONE_CHECK
        RET



DONE_INPUT
        ADD R5, R5, #0
        BRp INVALID
        ADD R6, R6, #0
        BRnp INVALID
        LEA R0, VAL_MSG
        PUTS
        BR DONE
INVALID LEA R0, INV_MSG
        PUTS
DONE    HALT

NEWLINE .FILL x000A
ASCII_0 .FILL x0030
ASCII_9 .FILL x0039
KBSR    .FILL xFE00
KBDR    .FILL xFE02
DSR     .FILL xFE04
DDR     .FILL xFE06
INV_MSG .STRINGZ "Invalid Phone Number."
VAL_MSG .STRINGZ "Valid Phone Number."

.END
