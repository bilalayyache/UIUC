#include <stdio.h>
int main()
{
  int sudoku[2][2] = {{1,2},
                      {0,0}};
  int i, j;
  int flag = 0;
  for (i = 0; i < 2; i++){          // finding a number that is not 0
    for (j = 0; j < 2; j++){
      if (sudoku[i][j] == 0){
        flag = 1;
        break;
      }
    }
    printf("i = %d, j = %d, flag = %d\n", i, j, flag);
    if (flag)
      break;
  }
  printf("\n");
  printf("i = %d, j = %d\n", i, j);
  return 0;
}
