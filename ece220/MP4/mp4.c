#include <stdlib.h>
#include <stdio.h>


int is_prime(int number);
int print_semiprimes(int a, int b);


int main(){
   int a, b;
   printf("Input two numbers: ");
   scanf("%d %d", &a, &b);
   if( a <= 0 || b <= 0 ){
     printf("Inputs should be positive integers\n");
     return 1;
   }

   if( a > b ){
     printf("The first number should be smaller than or equal to the second number\n");
     return 1;
   }

   // TODO: call the print_semiprimes function to print semiprimes in [a,b] (including a and b)
   int is_print;
   is_print = print_semiprimes(a, b);         // call the print_semiprimes function
   if (is_print == 0)                         // if the return value is 0, nothing is printed
    return 1;
   return 0;
}


/*
 * TODO: implement this function to check the number is prime or not.
 * Input    : a number
 * Return   : 0 if the number is not prime, else 1
 */
int is_prime(int number)
{
  // Return 1 if n is a prime, and 0 if it is not
  // set a flag to indicate whether the number is prime or not
  // variable reaminder is uesd to check whether m divides i
  int i, remainder, flag = 1;
  for (i = 2; i < number; i++){
    remainder = number % i;
    if (remainder == 0){              // if remainder = 0, i can divide number
      flag = 0;
      break;
    }
  }
  return flag;
}


/*
 * TODO: implement this function to print all semiprimes in [a,b] (including a, b).
 * Input   : a, b (a should be smaller than or equal to b)
 * Return  : 0 if there is no semiprime in [a,b], else 1
 */
int print_semiprimes(int a, int b)
{
  int i, m, n;      // i is the iteration variable that check all the values from a to b
                    // m, n are the variables that divide i (if i is not prime)
                    // we need to check whether m, n are primes
  int remainder;    // variable reaminder is uesd to check whether m divides i
  int flag_i, flag_m, flag_n;   // variable flag indicates whether a number is prime
  int flag;         // flag is used to indicate whether i is a semiprime
  int is_print = 0; // is_print indicates whether a number is printed out
  for (i = a; i <= b; i++)
  {
    flag = 0;                       // set flag = 0 before every loop
    flag_i = is_prime(i);           // if i itself is a prime. if so, go to next i
    if (flag_i == 1)
      continue;
    for (m = 2; m <= i; m++)        // try to find m, n such that i = m * n
    {
      flag_m = is_prime(m);         // if m is not a prime, fo to next m
      if (flag_m == 0)
        continue;
      remainder = i % m;            // if m divides i, let n = i / m
      if (remainder == 0)
      {
        n = i / m;
        flag_n = is_prime(n);       // if n is also a prime, ready to print i
        if (flag_n == 1)
        {
          printf("%d ", i);         // print i and set flag = 1, is_print = 1
          flag = 1;
          is_print = 1;
        }
      }
      if (flag == 1)                // if flag = 1, i is a semiprime, break to check next i
        break;
    }
  }
  printf("\n");
  return is_print;
}
