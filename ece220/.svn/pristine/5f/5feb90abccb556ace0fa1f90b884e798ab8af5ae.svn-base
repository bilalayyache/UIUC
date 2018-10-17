//Function for generating three d6 rolls
#include <stdlib.h>
int random1_6(int x);

void roll_three(int* one, int* two, int* three){
    int x;
    x = rand();
    *one = random1_6(x);
    x = rand();
    *two = random1_6(x);
    x = rand();
    *three = random1_6(x);

}

int random1_6(int x)
{
    int result;
    result = x % 6;
    result += 1;
    return result;
}
