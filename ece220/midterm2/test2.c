#include <stdio.h>

void swap(char *a, char *b){
  char temp;
  temp = *a;
  *a = *b;
  *b = temp;
}

void per(char *s, int left, int right){
  int i;
  if (left ==  right){
    printf("%s\n", s);
  }
  else{
    for (i = left; i <= right; i++){
      swap(&s[i], &s[left]);
      per(s, left + 1, right);
      swap(&s[i], &s[left]);
    }
  }
}

int main()
{
  char s[] = "DEF";
  per(s, 0, 2);
  return 0;
}
