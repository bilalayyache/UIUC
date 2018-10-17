#include <stdio.h>  
#include <math.h>  

int main()  
{  
    int a=256;
    int root=a;
    while (root>1)
    {
        printf("%d\n",root);
	root=sqrt(root);
    }
    printf("%d\n", 1);  

    return 0;
}  

