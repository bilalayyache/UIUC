.ORIG x3000

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
NEXT_digit  BRnz DONE                   ;To check whether 4 digits have already been printed out
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

DONE        HALT
ASCII_0     .FILL x0030
ASCII_A     .FILL x0041
.END
