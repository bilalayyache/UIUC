;number to print in decimal is in R3.
;it will be positive.
.ORIG x3000


; register table
; R0, R1: quotient and remainder of the program
; R2: holds the value of '0'
; R3: holds the value to be printed in decimal
; R4: holds the value #10
; R5: holds the value of underflow information
						ST R3, DECIMAL_SAVER3			; save original value of R3 and restore it at last
						LD R2, ASCII_0
						LD R4, DECIMAL_10
LOOP_DECIMAL
						JSR DIV
						ADD R3, R0, #0						; let R3 be the quotient after division
						ADD R0, R1, #0						; pass the remainder to R0 and ready to push the value in the stack
						ADD R0, R0, R2
						JSR PUSH
						ADD R3, R3, #0						; check if R3 = 0
						BRz DONE_DECIMAL					; if R3 = 0, ready to print out
						BRnzp LOOP_DECIMAL

DONE_DECIMAL
						JSR POP
						ADD R5, R5, #0
						BRp FINISH_DECIMAL				; if R5 = 1, underflow happened
						OUT
						BRnzp DONE_DECIMAL

FINISH_DECIMAL
						LD R3, DECIMAL_SAVER3
						HALT

DECIMAL_SAVER3	.BLKW #1
DECIMAL_10			.FILL #10
ASCII_0 				.FILL x0030
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0-quotient, R1-remainder
DIV
						ST R3, DIV_SAVER3					; first do callee-save
						ST R4, DIV_SAVER4
						AND R0, R0, #0						; Initialize R0 first
						ADD R0, R0, #-1
						NOT R4, R4
						ADD R4, R4, #1						; get the opposite value of R4
LOOP_DIV		ADD R0, R0, #1
						ADD R3, R3, R4						; subtract R4 from R3 and check whether the value is positive
						BRzp LOOP_DIV
						LD R4, DIV_SAVER4
						ADD R1, R3, R4						; get the remainder
						LD R3, DIV_SAVER3
						RET
DIV_SAVER3	.BLKW #1
DIV_SAVER4	.BLKW #1


;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH
	ST R3, PUSH_SaveR3	;save R3
	ST R4, PUSH_SaveR4	;save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACk_TOP	;
	ADD R3, R3, #-1		;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz OVERFLOW		;stack is full
	STR R0, R4, #0		;no overflow, store value in the stack
	ADD R4, R4, #-1		;move top of the stack
	ST R4, STACK_TOP	;store top of stack pointer
	BRnzp DONE_PUSH		;
OVERFLOW
	ADD R5, R5, #1		;
DONE_PUSH
	LD R3, PUSH_SaveR3	;
	LD R4, PUSH_SaveR4	;
	RET


PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;


;IN: R0, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP
	ST R3, POP_SaveR3	;save R3
	ST R4, POP_SaveR4	;save R3
	AND R5, R5, #0		;clear R5
	LD R3, STACK_START	;
	LD R4, STACK_TOP	;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz UNDERFLOW		;
	ADD R4, R4, #1		;
	LDR R0, R4, #0		;
	ST R4, STACK_TOP	;
	BRnzp DONE_POP		;
UNDERFLOW
	ADD R5, R5, #1		;
DONE_POP
	LD R3, POP_SaveR3	;
	LD R4, POP_SaveR4	;
	RET


POP_SaveR3	.BLKW #1	;
POP_SaveR4	.BLKW #1	;
STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;

.END
