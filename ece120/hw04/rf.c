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
	int i;
	printf("Please enter a number: ");
	scanf("%d", &factorial);

	/* Judge the input */
	while ((factorial < 0)|(factorial > 12)){
		printf("The input is not acceptable, try again.\n");
		printf("Please enter a number: ");
		scanf("%d", &factorial);
	}

	/* Compute factorial */
	result = 1;
	for (i = 1; i <= factorial; i = i+1) {
		result *= i;
	}
	/* Print the answer */
	printf("%d\n", result);

	return 0;
}
