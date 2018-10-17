#include "sudoku.h"

/*
Introduction Paragraph
In this file, it contains 7 functions, in which 4 of them are helper functions.
is_val_in_row, is_val_in_col, is_val_in_3x3_zone are functions to check whether the insert
    number are valid. If the same number has already existed in the same row, column or
    3x3 zone, the functions will output 1 and this means the value is not valid.
is_val_valid combines three functions above and gives the result whether this value is valid.
solve_sudoku is the function that uses recursion to find the solution for the matrix given.
print_sudoku is the function that print the input matrix and the result.
parse_sudoku is the function that read input matrix from txt file.
*/

//-------------------------------------------------------------------------------------------------
// Start here to work on your MP7
//-------------------------------------------------------------------------------------------------

// You are free to declare any private functions if needed.

// Function: is_val_in_row
// Return true if "val" already existed in ith row of array sudoku.
int is_val_in_row(const int val, const int i, const int sudoku[9][9]) {

  assert(i>=0 && i<9);

  // BEG TODO
  int j;                                // column pointer
  for (j = 0; j < 9; j++){
    if (val == sudoku[i][j])            // if find same value, return 1
      return 1;
  }
  return 0;
  // END TODO
}

// Function: is_val_in_col
// Return true if "val" already existed in jth column of array sudoku.
int is_val_in_col(const int val, const int j, const int sudoku[9][9]) {

  assert(j>=0 && j<9);

  // BEG TODO
  int i;                                // row pointer
  for (i = 0; i < 9; i++){
    if (val == sudoku[i][j])            // if find same value, return 1
      return 1;
  }
  return 0;
  // END TODO
}

// Function: is_val_in_3x3_zone
// Return true if val already existed in the 3x3 zone corresponding to (i, j)
int is_val_in_3x3_zone(const int val, const int i, const int j, const int sudoku[9][9]) {

  assert(i>=0 && i<9);

  // BEG TODO
  int m, n;                // m, n are used to find the place of (i, j) in 3x3 zone
  m = i % 3;
  n = j % 3;
  int ii, jj;              // row and column pointers
  for (ii = i - m; ii < i - m + 3; ii++){     // 3x3 zone is from (i-m,j-n) to (i-m+2, j-n+2)
    for (jj = j - n; jj < j - n + 3; jj++){
      if (sudoku[ii][jj] == val)
        return 1;
    }
  }
  return 0;
  // END TODO
}

// Function: is_val_valid
// Return true if the val is can be filled in the given entry.
int is_val_valid(const int val, const int i, const int j, const int sudoku[9][9]) {

  assert(i>=0 && i<9 && j>=0 && j<9);

  // BEG TODO
  int flag = 0;      // flag is used to receive return values from three helper functions above
  flag += is_val_in_row(val, i, sudoku);
  flag += is_val_in_col(val, j, sudoku);
  flag += is_val_in_3x3_zone(val, i, j, sudoku);
  if (flag == 0)    // if flag = 0, all three functions give 0 and the value can be set
    return 1;
  else
    return 0;
  // END TODO
}

// Procedure: solve_sudoku
// Solve the given sudoku instance.
int solve_sudoku(int sudoku[9][9]) {

  // BEG TODO
  int i, j;             // row and column pointer
  int num;              // num is used as the value than fill in the  matrix
  int flag = 1;         // flag is used to check whether matrix is full and reveive return value of is_val_valid function
  for (i = 0; i < 9; i++){         // set up base case (i.e. if all values are filled)
    for (j = 0; j < 9; j++){
      if (sudoku[i][j] == 0)
        flag = 0;
    }
  }
  if (flag == 1)
    return 1;
  for (i = 0; i < 9; i++){          // finding a number that is not 0
    for (j = 0; j < 9; j++){
      if (sudoku[i][j] == 0)
        break;
    }
    if (j == 9)                     // boundary check
      continue;
    if (sudoku[i][j] == 0)
      break;
  }
  for (num = 1; num <= 9; num++){
    flag = is_val_valid(num, i, j, sudoku);   // if flag = 1, num can be set
    if (flag == 1){
      sudoku[i][j] = num;                     // set the value and do recursion
      if (solve_sudoku(sudoku))
        return 1;
      sudoku[i][j] = 0;                       // backtrack step
    }
  }
  return 0;
  // END TODO.
}

// Procedure: print_sudoku
void print_sudoku(int sudoku[9][9])
{
  int i, j;
  for(i=0; i<9; i++) {
    for(j=0; j<9; j++) {
      printf("%2d", sudoku[i][j]);
    }
    printf("\n");
  }
}

// Procedure: parse_sudoku
void parse_sudoku(const char fpath[], int sudoku[9][9]) {
  FILE *reader = fopen(fpath, "r");
  assert(reader != NULL);
  int i, j;
  for(i=0; i<9; i++) {
    for(j=0; j<9; j++) {
      fscanf(reader, "%d", &sudoku[i][j]);
    }
  }
  fclose(reader);
}
