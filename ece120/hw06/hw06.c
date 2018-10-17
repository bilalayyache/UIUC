#include <stdio.h>
int main()
{
	unsigned int w, x, y, z;
	unsigned int f, g;

	/* Print header for K-map. */
	printf("         yz      \n");
	printf("     00 01 11 10 \n");
	printf("   ______________\n");

	/* row-printing loop */
	for (w = 0; 2 > w; w++){

		printf("a=%u | ", a);
 
		/* Loop over input variable b in binary order. */
		for (b = 0; 2 > b; b = b + 1){

			/* Loop over d in binary order.*/
			for (d = 0; 2 > d; d = d + 1){

				/* Use variables b and d to calculate *
		 		* input variable c (iterated in      *
		 		* Gray code order).                  */
				/* We can find that c = b XOR d      */
				c = b ^ d;

				/* Calculate and print one K-map entry *
				 * (function F(a,b,c) ).               */
				/* Careful about the &1 at last because*
				 * the variable here is 32-bit         */
				f = (a|~c) & (~b|~c) & (~a|b|c) & 1;
				printf("%u  ",f);
            		}
        	}

		/* End of row reached: print a newline character. */
	   	printf("\n");
	}

	return 0;
}
