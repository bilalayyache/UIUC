#include <stdio.h>
#include "prime.h"

int main(){
  // Write the code to take a number n from user and print all the prime numbers between 1 and n
  int n;  // assume n >= 2
  printf("Enter the value of n: ");
  scanf("%d", &n);
  printf("Printing primes less than or equal to %d:\n", n);
  int i, result;
  for (i = 2; i <= n ; i++){
    result = is_prime(i);
    if (result == 1)
      printf("%d ", i);
  }
  printf("\n");
  return 0;
}
