.ORIG x3000

LD R1, INPUT
JSR FIBON
ST R6, RESULT
HALT

;your code goes here
FIBON

; input R1 = k
; output R6 = F_k
; R2 = #-2
; R3 = F_low
; R4 = F_high
              ST R1, FIBON_SAVER1
              ST R2, FIBON_SAVER2
              ST R3, FIBON_SAVER3
              ST R4, FIBON_SAVER4
              AND R6, R6, #0
              LD R2, NUMBER_N2
              ADD R1, R1, R2
              BRnz SMALL
              AND R3, R3, #0
              ADD R3, R3, #1
              AND R4, R4, #0
              ADD R4, R4, #1
LOOP          ADD R6, R3, R4
              BRnz ERROR
              ADD R3, R4, #0
              ADD R4, R6, #0
              ADD R1, R1, #-1
              BRz DONE
              BRnzp LOOP


ERROR         AND R6, R6, #0
              ADD R6, R6, #-1
              BRnzp DONE

SMALL         AND R6, R6, #0
              ADD R6, R6, #1

DONE          LD R1, FIBON_SAVER1
              LD R2, FIBON_SAVER2
              LD R3, FIBON_SAVER3
              LD R4, FIBON_SAVER4
              RET

NUMBER_N2 .FILL xFFFE
INPUT 	.FILL x0005
RESULT	.BLKW #1
FIBON_SAVER1  .BLKW #1
FIBON_SAVER2	.BLKW #1
FIBON_SAVER3	.BLKW #1
FIBON_SAVER4	.BLKW #1
.END
