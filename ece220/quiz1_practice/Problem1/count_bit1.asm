
.ORIG x3000

INIT_REGS
  AND R0, R0, #0
  AND R1, R1, #0
  AND R2, R2, #0
  AND R3, R3, #0
  AND R4, R4, #0
  AND R5, R5, #0
  AND R6, R6, #0

  LD R6, INPUT_ADDRESS
  LDR R6, R6, #0

; TODO

; let R0 be the counter
; let R1 = R6 - #1

COUNT         ADD R6, R6, #0
              BRz DONE
              ADD R1, R6, #-1
              AND R6, R1, R6
              ADD R0, R0, #1
              BRnzp COUNT

DONE
; END TODO

	STI R0, OUTPUT_VALUE

HALT

; Memory definition.
INPUT_ADDRESS .FILL x5000
OUTPUT_VALUE .FILL x5000

.END
