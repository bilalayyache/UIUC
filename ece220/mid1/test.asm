            .ORIG x3000
            LEA R0, STRING
            ADD R1, R0, #0
            LD R4, SPACE

NEXT        LDR R2, R0, #0
            ADD R3, R2, R4
            BRnp NOTSPACE
            ADD R0, R0, #1
            BR NEXT

NOTSPACE    STR R2, R1, #0
            ADD R0, R0, #1
            ADD R1, R1, #1
            ADD R2, R2, #0
            BRnp NEXT

DONE        HALT

SPACE .FILL #-32
STRING .STRINGZ "ECE 220 !"
.END
