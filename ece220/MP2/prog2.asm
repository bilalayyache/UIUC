;
;
;
.ORIG x3000

;your code goes here
; register table in main function
; R0: holds the input character and output string
; R1: store negative value of '0'
; R2: store negative value of space
; and R2 holds STACK_START
; R4: holds the comparison value
; R6: STACK_TOP


; Set R5 as a flag. If R5 = 1, error has happened (overflow/underflow/invalid input)
						AND R3, R3, #0				; initialize R3
						AND R5, R5, #0				; initialize R5
NEXT_CHAR
						LD R1, NEG_EQ
						LD R2, NEG_SPACE
						GETC
						OUT
						ADD R4, R0, R1        ; determine whether the char is '='
						BRz EQUAL
						ADD R5, R5, #0
						BRp NEXT_CHAR
						ADD R4, R0, R2				; determine whether the char is space
						BRz NEXT_CHAR
						JSR EVALUATE
						BRnzp NEXT_CHAR


EQUAL				ADD R5, R5, #0				; check the flag, if R5 = 1, then output Invalid Expression
						BRp INVALID
						JSR POP
						ADD R5, R5, #0				; check underflow
						BRp INVALID
						LD R6, STACK_TOP			; check the remaining of the stack
						LD R2, STACK_START
						NOT R6, R6
						ADD R6, R6, #1
						ADD R6, R2, R6
						BRnp INVALID
						ADD R3, R0, #0				; pass the result to R3
																	; and use the PRINT_HEX to print hex on the screen
						JSR PRINT_HEX
						BRnzp DONE

INVALID			LEA R0, I_E
						PUTS
DONE				HALT

I_E					.STRINGZ "Invalid Expression"
NEG_SPACE		.FILL xFFE0
NEG_EQ			.FILL xFFC3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R3- value to print in hexadecimal
PRINT_HEX

;First do callee-save for registers

						ST R1, PRINT_HEX_SAVER1
						ST R2, PRINT_HEX_SAVER2
						ST R3, PRINT_HEX_SAVER3
						ST R4, PRINT_HEX_SAVER4
						ST R7, PRINT_HEX_SAVER7

;There is a value that is stored in R3 and we need to print its hex on monitor.
;Register Form
;R0   Used to print out ASCII character
;R1   Used as a digit counter
;R2   Used as a bit counter
;R3   Store the value that needed to be printed out
;R4   Store the current digit that we need to print out

            ;Initialize digit counter R1
            AND R1, R1, #0
            ADD R1, R1, #4
NEXT_digit  BRnz DONE_PRINT             ;To check whether 4 digits have already been printed out
            AND R2, R2, #0              ;Initialize R2
            AND R4, R4, #0              ;Initialize R4
            ADD R2, R2, #4
NEXT_bit    BRnz DONE_digit             ;To check whether 4 times of left shift have been done
            ADD R4, R4, R4              ;Shift R4 left for one bit
            ADD R3, R3, #0              ;Check the first digit of R3 is 1 or 0
            BRzp POSITIVE               ;If positive, go to POSITIVE
            ADD R4, R4, #1              ;If negative, add 1 to R4
POSITIVE    ADD R3, R3, R3              ;Shift R3 left for one bit
            ADD R2, R2, #-1             ;Decrease bit counter by 1
            BRnzp NEXT_bit

DONE_digit  ADD R4, R4, #-10            ;Ready to compare R4 and #10
            BRn NUMBER                  ;If R4 < 10, ready to print the number
            LD R0, ASCII_A              ;R0 is the ASCII code for 'A'
            ADD R0, R0, R4              ;R0 is now the ASCII code for what stored in R4
            BRnzp PRINT                 ;Print the character

NUMBER      LD R0, ASCII_0
            ADD R4, R4, #10             ;Recover R4
            ADD R0, R0, R4              ;R0 is the ASCII code for what stored in R4
PRINT       OUT                         ;Print the hex
            ADD R1, R1, #-1
            BRnzp NEXT_digit

DONE_PRINT  LD R1, PRINT_HEX_SAVER1
						LD R2, PRINT_HEX_SAVER2
						LD R5, PRINT_HEX_SAVER3			; load the output expression into R5
						LD R4, PRINT_HEX_SAVER4
						LD R7, PRINT_HEX_SAVER7
						RET
ASCII_0     .FILL x0030
ASCII_A     .FILL x0041
PRINT_HEX_SAVER1	.BLKW #1
PRINT_HEX_SAVER2	.BLKW #1
PRINT_HEX_SAVER3	.BLKW #1
PRINT_HEX_SAVER4	.BLKW #1
PRINT_HEX_SAVER7	.BLKW #1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R0 - character input from keyboard
;R6 - current numerical output
;
;
EVALUATE

; register table
; R5: flag. If R5 = 1, there is an error (underflow/overflow/invalid input)
; R3, R4: store value operands popped from stack
; R0: results of the calculation
; R1: store the negative value of operands to be checked
; R2: comparison result
; when pushing values into stack, remember to transform the ascii value to decimal value
;your code goes here
						ST R7, EVALUATE_SAVER7				; callee-save for R7
						LD R1, NEG_0
						ADD R2, R0, R1
						BRn NOT_NUMBER								; if R0 < '0', then program goes to CHECK_OPERATOR
						LD R1, NEG_9
						ADD R2, R0, R1
						BRnz OP_NUMBER								; if R0 <= '9', then program goes to NUMBER
						BRnzp NOT_NUMBER

OP_NUMBER
						LD R1, NEG_0									; we should push the decimal value
						ADD R0, R0, R1								; so we subtract '0' from the input
						JSR PUSH
						BRnzp DONE_EVALUATION

NOT_NUMBER
						LD R1, NEG_PLUS								; whether the operation is '+'
						ADD R2, R0, R1
						BRz OP_PLUS
						LD R1, NEG_MINUS							; whether the operation is '-'
						ADD R2, R0, R1
						BRz OP_MINUS
						LD R1, NEG_TIMES							; whether the operation is '*'
						ADD R2, R0, R1
						BRz OP_TIMES
						LD R1, NEG_DIV								; whether the operation is '/'
						ADD R2, R0, R1
						BRz OP_DIV
						LD R1, NEG_POWER							; whether the operation is '^'
						ADD R2, R0, R1
						BRz OP_POWER
						ADD R5, R5, #1								; else, it is a invalid input character
						BRnzp DONE_EVALUATION

OP_PLUS			JSR FETCH											; for '+' operation
						ADD R5, R5, #0								; check whether there is an underflow
						BRp DONE_OP_PLUS
						JSR PLUS
						JSR PUSH
DONE_OP_PLUS
						BRnzp DONE_EVALUATION

OP_MINUS		JSR FETCH											; for '-' operation
						ADD R5, R5, #0								; check whether there is an underflow
						BRp DONE_OP_MINUS
						JSR MIN
						JSR PUSH
DONE_OP_MINUS
						BRnzp DONE_EVALUATION

OP_TIMES		JSR FETCH											; for '*' operation
						ADD R5, R5, #0								; check whether there is an underflow
						BRp DONE_OP_TIMES
						JSR MUL
						JSR PUSH
DONE_OP_TIMES
						BRnzp DONE_EVALUATION

OP_DIV			JSR FETCH											; for '/' operation
						ADD R5, R5, #0								; check whether there is an underflow
						BRp DONE_OP_DIV
						JSR DIV
						JSR PUSH
DONE_OP_DIV
						BRnzp DONE_EVALUATION

OP_POWER		JSR FETCH											; for '^' operation
						ADD R5, R5, #0								; check whether there is an underflow
						BRp DONE_OP_POWER
						JSR EXP
						JSR PUSH
DONE_OP_POWER
						BRnzp DONE_EVALUATION

DONE_EVALUATION
						LD R7, EVALUATE_SAVER7
						RET
EVALUATE_SAVER7	.BLKW #1
NEG_0				.FILL xFFD0
NEG_9				.FILL xFFC7
NEG_PLUS		.FILL xFFD5
NEG_MINUS		.FILL xFFD3
NEG_TIMES		.FILL xFFD6
NEG_DIV			.FILL XFFD1
NEG_POWER		.FILL xFFA2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FETCH
; in this subroutine, program will fetch two number operands when input an operator
; output R3, R4
						ST R7, FETCH_SAVER7						; save R7 before manipulating
						LD R1, NEG_0									; load R1 as negative value of '0'
						JSR POP
						ADD R5, R5, #0
						BRp DONE_FETCH								; if R5 = 1, underflow happened
						ADD R4, R0, #0								; assign the second number to R4
						JSR POP
						ADD R5, R5, #0
						BRp DONE_FETCH								; if R5 = 1, underflow happened
						ADD R3, R0, #0								; assign the second number to R3
DONE_FETCH	LD R7, FETCH_SAVER7
						RET

FETCH_SAVER7	.BLKW #1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
PLUS
;your code goes here
						ADD R0, R3, R4
						RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MIN
;your code goes here
						ST R1, MIN_SAVER1
						NOT R1, R4
						ADD R1, R1, #1
						ADD R0, R1, R3
						LD R1, MIN_SAVER1
						RET
MIN_SAVER1	.BLKW #1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MUL
;your code goes here
						ST R3, MUL_SAVER3
						AND R0, R0, #0						; Initialize R0 to get the result
						ADD R3, R3, #0						; check whether R3 is positive
						BRn MUL_NEG
LOOP_MUL		ADD R3, R3, #0						; check whether R3 is 0
						BRz DONE_MUL
						ADD R0, R0, R4
						ADD R3, R3, #-1
						BRnzp LOOP_MUL

MUL_NEG			ADD R0, R0, R4
						ADD R3, R3, #1
						BRn MUL_NEG
						NOT R0, R0								; after calculation, we should negate R0
						ADD R0, R0, #1
DONE_MUL		LD R3, MUL_SAVER3
						RET
MUL_SAVER3	.BLKW #1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
DIV
;your code goes here
						ST R3, DIV_SAVER3
						ST R4, DIV_SAVER4
						AND R0, R0, #0						; Initialize R0 first
						ADD R0, R0, #-1
						NOT R4, R4
						ADD R4, R4, #1						; get the opposite value of R4
LOOP_DIV		ADD R0, R0, #1
						ADD R3, R3, R4						; subtract R4 from R3 and check whether the value is positive
						BRzp LOOP_DIV
						LD R3, DIV_SAVER3
						LD R4, DIV_SAVER4
						RET
DIV_SAVER3	.BLKW #1
DIV_SAVER4	.BLKW #1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
EXP
;your code goes here
;in this subroutine, I will use the subroutine MUL above
;I will multiple R3 by itself #R4 times.
;first let R5(a count down counter) holds the value of R4 and R4 holds the value of R3
;and use MUL until R5 = 0
						ST R7, EXP_SAVER7
						ST R4, EXP_SAVER4
						ST R5, EXP_SAVER5
						AND R0, R0, #0						; Initialize R0 to get the result
						ADD R5, R4, #-1						; R5 acts as a count down counter
						ADD R4, R3, #0
LOOP_EXP		JSR MUL
						ADD R4, R0, #0						; R4 <- R0, and do next multiplication
						ADD R5, R5, #-1
						BRp LOOP_EXP
						LD R4, EXP_SAVER4
						LD R5, EXP_SAVER4
						LD R7, EXP_SAVER7
						RET
EXP_SAVER4	.BLKW #1
EXP_SAVER5	.BLKW #1
EXP_SAVER7	.BLKW #1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
	NOT R3, R3				;
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


;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
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
