#include <stdio.h>

typedef struct students
{
  int UIN;
  char name[100];
}student;

int main()
{
  students s1 = {123, "abc"};
  printf("%s\n", s1.name);
  printf("%s\n", (&s1)->name);
  return 0;
}
