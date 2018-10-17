#include "prime.h"

int is_prime(int n){
  // Return 1 if n is a prime, and 0 if it is not
  int i, remainder, flag = 1;
  for (i = 2; i < n; i++){
    remainder = n % i;
    if (remainder == 0){
      flag = 0;
      break;
    }
  }

  return flag;
}
