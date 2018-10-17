#include <stdio.h>
#include <stdlib.h>

int main()
{
  int row;

  printf("Enter a row index: ");
  scanf("%d",&row);

  // Write your code here
  unsigned long int coef = 1;                 // define the result coef
  int i = 0;                                  // define three variable i.
                                              // i is iteration variable
  while (i <= row)
  {
    if (i == 0)                               // if i == 0, print 1
      printf("1 ");
    else                                      // if i != 0, do the calculation step by step and print out the result
    {
      coef = coef * (row + 1 - i) / i;
      printf("%lu ", coef);
    }
    i++;
  }
  printf("\n");
  return 0;
}
