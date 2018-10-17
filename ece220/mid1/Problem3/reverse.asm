;Reverse Characters
;n characters are provided to you
;in which n is a positive number stored at x4FFF
;characters stored in sequential memory location
;starting at x5000
;Use the subroutine REVERSE to flip the order

.ORIG x3000

;your program starts here
              JSR REVERSE
              HALT


;REVERSE subroutine:
;reverse the order of n characters starting at x5000
;SWAPMEM subroutine must be called here, not in the main user program
; R2: numbers of char
; R0: front pointer
; R1: back pointer
; R3: compare bit

REVERSE
              ST R7, SAVER7_REVERSE
              LDI R2, NUM_ADDR
              LD R0, CHAR_ADDR
              ADD R1, R0, R2
              ADD R1, R1, #-1
NEXT          NOT R3, R0
              ADD R3, R3, #1
              ADD R3, R3, R1
              BRnz DONE
              JSR SWAPMEM
              ADD R0, R0, #1
              ADD R1, R1, #-1
              BR NEXT
DONE
              LD R7, SAVER7_REVERSE
              RET
SAVER7_REVERSE  .BLKW #1



;SWAPMEM subroutine:
;address one is in R0, address two in R1
;if mem[R0]=A and mem[R1]=B, then after subroutine call
;   mem[R0]=B and mem[R1]=A
SWAPMEM
              ST R3, SAVER3_SWAPMEM
              ST R4, SAVER4_SWAPMEM
              ST R5, SAVER5_SWAPMEM
              LDR R3, R0, #0
              LDR R4, R1, #0
              ADD R5, R3, #0
              ADD R3, R4, #0
              ADD R4, R5, #0
              STR R3, R0, #0
              STR R4, R1, #0
              LD R3, SAVER3_SWAPMEM
              LD R4, SAVER4_SWAPMEM
              LD R5, SAVER5_SWAPMEM
              RET
SAVER3_SWAPMEM  .BLKW #1
SAVER4_SWAPMEM  .BLKW #1
SAVER5_SWAPMEM  .BLKW #1

NUM_ADDR    .FILL x4FFF
CHAR_ADDR   .FILL x5000

.END
