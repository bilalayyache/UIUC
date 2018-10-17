#include <stdio.h>

int main()
{
	int x,y;
	scanf("%d %d",&x,&y);
	printf("x&y=%d\n",x&y);
	printf("x|y=%d\n",x|y);
	printf("y>>3=%d\n",y>>3);
	printf("x^y=%d\n",x^y);
	printf("~x=%d\n",~x);
	printf("(-y)>>3=%d\n",(-y)>>3);
	printf("(x+y)/3=%d\n",(x+y)/3);
	return 0;
}
