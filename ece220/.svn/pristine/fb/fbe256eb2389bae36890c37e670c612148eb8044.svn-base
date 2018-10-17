#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(){
  // Start your code here
  int n, i;
  double omega1, omega2;
  printf("Enter the values of n, omega1, omega2 in that order\n");
  scanf("%d %lf %lf", &n, &omega1, &omega2);
  double x, f;
  for (i = 0; i < n; i++)
  {
    x = i * M_PI / n;
    f = sin(omega1 * x) + 0.5 * sin(omega2 * x);
    printf("(%f, %f)\n", x, f);
  }
  return 0;
}
