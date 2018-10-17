/*
 *	
 *  Factorial!: Computes the factorial of a positive integer
 *
 */

#include <stdio.h>

int main()
{
    /* Initialization */
    int factorial;   /* input to be entered by the user */
    int result;      /* result,  factorial! */

    printf("Please enter a number: ");
    scanf("%d", &factorial);

    int i;
    /* Compute factorial */
    result = 1;
    for (i = factorial; i > 0; i = i-1) {
        result *= i;
    }
    /* Print the answer */
    printf("%d\n", result);

    return 0;
}
