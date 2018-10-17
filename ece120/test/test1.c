#include <stdio.h>

int main()
{
	int x,y,z,f;
	printf("\nTruth Table\n");
	printf("x y z   f\n");

	for (x=0;x<=1;x++)
	{
		for (y=0;y<=1;y++)
		{
			for (z=0;z<=1;z++)
			{
				f=((~x&~y&~z)|(~x&~y&z)|(~x&y&z)|(x&~y&z)|(x&y&z));
				printf("%d %d %d   %d\n",x,y,z,f);
			}
		}
	}
	return 0;
}
