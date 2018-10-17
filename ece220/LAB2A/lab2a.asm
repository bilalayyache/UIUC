.ORIG x3000
; Write code to read in characters and echo them
; till a newline character is entered.

; table of registers
; R0: get the input from the keyboard
; R1: get the negative value of open parenthesis
; and get the address of STACK_TOP
; R2: get the negative value of close parenthesis
; and get the address of STACK_START
; R3: get the negative value of newline
; R4: temporary register to hold the comparison value
; R5: indicator, whether the string is balanced
; R6: indicator of underflow/overflow happened

; Initialize R1, R2, R3, R5, R6
LD R1, NEG_OPEN
LD R2, NEG_CLOSE
LD R3, NEG_NL
AND R5, R5, #0
AND R6, R6, #0

NEXT_CHAR
GETC
OUT                   ; echo character from keyboard
ADD R4, R0, R3        ; determine whether the char is newline
BRz NL
ADD R4, R0, R1        ; determine whether the char is '('
BRz ISBALANCED
ADD R4, R0, R2        ; determine whether the char is ')'
BRz ISBALANCED
BRnzp NEXT_CHAR       ; if else, go to next character

ISBALANCED
ADD R6, R6, #0        ; if R6 is not zero, overflow/underflow happened
BRnp NEXT_CHAR
JSR IS_BALANCED
BRnzp NEXT_CHAR

NL      LD R1, STACK_TOP      ; if STACK_TOP = STACK_START, then is balanced
LD R2, STACK_START
NOT R1, R1
ADD R1, R1, #1
ADD R1, R1, R2
BRnp NOT_BALANCED
ADD R6, R6, #0        ; if R6 is not zero, is not balanced
BRnp NOT_BALANCED
AND R5, R5, #0
ADD R5, R5, #1
BRnzp DONE

NOT_BALANCED
AND R5, R5, #0
ADD R5, R5, #-1
DONE    HALT

SPACE           .FILL x0020
NEW_LINE        .FILL x000A
CHAR_RETURN     .FILL x000D
NEG_OPEN        .FILL xFFD8
NEG_CLOSE       .FILL xFFD7
NEG_NL          .FILL xFFF6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;if '(' push onto stack, if ')' pop from stack and check if popped value is '('
;input - R0 holds the input
;output - R5 set to -1 if unbalanced. else not modified.
IS_BALANCED
ST R4, SAVE_R4          ; do callee-save
ST R7, SAVE_R7

LD R4, NEG_CLOSE        ; whether char is ')'
ADD R4, R0, R4
BRz CLOSE

JSR PUSH                ; char = '('
BRnzp DONE_BALANCED

CLOSE
JSR POP
ADD R5, R5, #0          ; if R5 = 1(i.e. underflow), set R5 = -1(unbalanced)
BRnz DONE_BALANCED
ADD R6, R6, #1

DONE_BALANCED

LD R7, SAVE_R7
RET

SAVE_R4       .BLKW #1
SAVE_R7       .BLKW #1
;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH
ST R3, PUSH_SaveR3      ;save R3
ST R4, PUSH_SaveR4      ;save R4
AND R5, R5, #0          ;
LD R3, STACK_END        ;
LD R4, STACk_TOP        ;
ADD R3, R3, #-1         ;
NOT R3, R3              ;
ADD R3, R3, #1          ;
ADD R3, R3, R4          ;
BRz OVERFLOW            ;stack is full
STR R0, R4, #0          ;no overflow, store value in the stack
ADD R4, R4, #-1         ;move top of the stack
ST R4, STACK_TOP        ;store top of stack pointer
BRnzp DONE_PUSH         ;
OVERFLOW
ADD R5, R5, #1          ;
DONE_PUSH
LD R3, PUSH_SaveR3      ;
LD R4, PUSH_SaveR4      ;
RET


PUSH_SaveR3     .BLKW #1        ;
PUSH_SaveR4     .BLKW #1        ;


;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP
ST R3, POP_SaveR3       ;save R3
ST R4, POP_SaveR4       ;save R3
AND R5, R5, #0          ;clear R5
LD R3, STACK_START      ;
LD R4, STACK_TOP        ;
NOT R3, R3              ;
ADD R3, R3, #1          ;
ADD R3, R3, R4          ;
BRz UNDERFLOW           ;
ADD R4, R4, #1          ;
LDR R0, R4, #0          ;
ST R4, STACK_TOP        ;
BRnzp DONE_POP          ;
UNDERFLOW
ADD R5, R5, #1          ;
DONE_POP
LD R3, POP_SaveR3       ;
LD R4, POP_SaveR4       ;
RET


POP_SaveR3      .BLKW #1        ;
POP_SaveR4      .BLKW #1        ;
STACK_END       .FILL x3FF0     ;
STACK_START     .FILL x4000     ;
STACK_TOP       .FILL x4000     ;

.END
