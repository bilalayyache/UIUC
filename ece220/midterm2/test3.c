#include <stdio.h>

int main()
{
  int arr1[5] = {1, 2, 3, 4, 5};
  int *arr2[5];
  int i;
  for (i = 0; i < 5; i++){
    // arr2[i] = arr1 + i;
    arr2[i] = &arr1[i];
  }

  for (i = 0; i < 5; i++){
    printf("%p\n", arr2[i]);
  }
  return 0;
}
