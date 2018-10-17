;Load ASCII art character, stored at memory address x5000 (IMAGEADDR)
;The first two numbers are the width (number of columns) and the height (number of rows) in the ASCII art image
;The memory addresses starting at x5002 are ASCII characters. The first N characters are the first row of the image, the second N characters are the second row of the image, etc.
;each row should end with a newline character

.ORIG x3000
;YOUR CODE GOES HERE
; R1 char pointer
; R2 = N, column
; R3 = M, row
; R0 output


          LD R1, IMAGEADDR
          LDI R2, VALUE_N
          LDI R3, VALUE_M
          ADD R1, R1, #2

NEXT_CHAR
          LDR R0, R1, #0
          OUT
          ADD R1, R1, #1
          ADD R2, R2, #-1
          BRp NEXT_CHAR
          LD R0, NEWLINE
          OUT
          LDI R2, VALUE_N
          ADD R3, R3, #-1
          BRp NEXT_CHAR
          HALT



NEWLINE   .FILL x000A
IMAGEADDR .FILL x5000; address of image
VALUE_N   .FILL x5000;
VALUE_M   .FILL x5001;
.END
