#include "sliding.h"
/*  Slide all values of array up
*/
void slide_up(int* my_array, int rows, int cols){
  int i, j;                   // row and column indices
  int k;                      // when encounter a -1, move all values below
  for (j = 0; j < cols; j++){
    for (i = 0; i < rows; i++){
      if (my_array[i * cols + j] == -1){      // if encounter a -1, do swap
        for (k = i + 1; k < rows; k++){       // to do swap, need to find a number that is not -1
          if (my_array[k * cols + j] != -1){
            my_array[i * cols + j] = my_array[k * cols + j]; // do the swap
            my_array[k * cols + j] = -1;
            break;                            // everytime you only do one swap. so break here
          }
        }
      }
    }
  }
  return;
}

/***************************************************************************/

int slide_left(int* my_array, int rows, int cols)
{
  int i, j;                   // row and column indices
  int k;                      // when encounter a -1, move all values below
  int flag = 0;               // return value of the function
  for (i = 0; i < rows; i++){
    for (j = 0; j < cols-1; j++){
      if (my_array[i * cols + j] == -1){      // if encounter a -1, do swap
        for (k = j + 1; k < cols; k++){       // to do swap, need to find a number that is not -1
          if (my_array[i * cols + k] != -1){
            my_array[i * cols + j] = my_array[i * cols + k]; // do the swap
            my_array[i * cols + k] = -1;
            flag = 1;
            break;                            // everytime you only do one swap. so break here
          }
        }
      }
    }
  }
  return flag;
}

void shift_left(int* my_array, int rows, int cols)
{
  int *board = my_array;
  slide_left(board, rows, cols);
  int i, j;                                   // row and column counters
  for (j = 0; j < cols - 1; j++){             // to check merge, only need to go to (cols-1)
    for (i = 0; i < rows; i++){
      if (board[i * cols + j] == -1)
        continue;
      if (board[i * cols + j] == board[i * cols + j + 1]){
        board[i * cols + j] = 2 * board[i * cols + j];
        board[i * cols + j + 1] = -1;
      }
    }
  }
  slide_left(board, rows, cols);
}
