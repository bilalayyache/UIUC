#include <stdio.h>
#include <stdlib.h>

unsigned long factorial(unsigned long x);

int main()
{
  int row;

  printf("Enter a row index: ");
  scanf("%d",&row);

  // Write your code here
  unsigned long num, den;                 // define two variables: numerator and denominator
  unsigned long result;                   // define three variable result, i
  int i;                                  // result is used to store the output value and i is iteration variable
  num = factorial(row);
  for (i = 0; i <= row; i++)
  {
    den = factorial(i) * factorial(row - i);
    result = num / den;
    printf("%lu ", result);

  }
  printf("\n");
  return 0;
}
unsigned long factorial(unsigned long x)
{
  unsigned long mul = 1;
  while (x >= 1){
    mul = mul * x;
    x -= 1;
  }
  return mul;
}
