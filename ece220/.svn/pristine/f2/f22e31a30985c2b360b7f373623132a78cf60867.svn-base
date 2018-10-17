/* Code to simulate rolling three six-sided dice (D6)
 * User first types in seed value
 * Use seed value as argument to srand()
 * Call roll_three to generate three integers, 1-6
 * Print result "%d %d %d "
 * If triple, print "Triple!\n"
 * If it is not a triple but it is a dobule, print "Double!\n"
 * Otherwise print "\n"
 */


#include <stdio.h>
#include <stdlib.h>
#include "dice.h"

int main()
{
  int *one, *two, *three;
  int a, b, c, seed;
  one = &a;
  two = &b;
  three = &c;
  printf("Please enter a seed number: ");
  scanf("%d", &seed);
  srand(seed);
  roll_three(one, two, three);
  if (a == b)
  {
    if (a == c)
      printf("%d %d %d Triple!\n", a, b, c);
    else
      printf("%d %d %d Double!\n", a, b, c);
  }
  else if (a == c)
    printf("%d %d %d Double!\n", a, b, c);
  else if (b == c)
    printf("%d %d %d DOuble!\n", a, b, c);
  else
    printf("%d %d %d\n", a, b, c);
  return 0;
}
