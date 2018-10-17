#include <stdio.h>

int main()
{
	unsigned int w, x, y, z;
	unsigned int a, b;
	unsigned int f, g;

	// For f(w,x,y,z):
	printf("f(w,x,y,z):\n");
	printf("            yz      \n");
	printf("        00 01 11 10 \n");
	printf("     _______________\n");
	// Begin the loop of the row
	for (w=0; w<2; w++){
		for (a=0; a<2; a++){
			// Calculate x in terms of a & w
			x = a^w;
			printf("wx=%u%u |",w,x);
			// Begin the loop of the column
			for (y=0; y<2;y++){
				for (b=0; b<2; b++){
					// Calculate z in terms of b & y
					z = b^y;
					// Calculate the function
					f = ((x&~y)|(~w&z))&1;
					printf("  %u",f);
				}
			}
			printf("\n");
		}
	}
	printf("\n");

	// For g(w,x,y,z):
	printf("g(w,x,y,z):\n");
	printf("            yz      \n");
	printf("        00 01 11 10 \n");
	printf("     _______________\n");
	// Begin the loop of the row
	for (w=0; w<2; w++){
		for (a=0; a<2; a++){
			// Calculate x in terms of a & w
			x = a^w;
			printf("wx=%u%u |",w,x);
			// Begin the loop of the column
			for (y=0; y<2;y++){
				for (b=0; b<2; b++){
					// Calculate z in terms of b & y
					z = b^y;
					// Calculate the function
					g = ((~w&x&y&~z)|w|~x)&1;
					printf("  %u",g);
				}
			}
			printf("\n");
		}
	}
	return 0;
}
