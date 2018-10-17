#include <stdio.h>
int main()
{
	float a, b, c, s1, s2;
	scanf("%f %f %f", &a, &b, &c);
	s1 = a + b + c;
	s2 = a + c + b;
	printf("%f %f\n", s1, s2);
	return 0;
}
