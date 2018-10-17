#include <stdio.h>

int findpair(int *array, int start, int end){
    int flag = 0;
    int i, j;
    for(i = start; i < end; i++){
        for (j = i + 1; j <= end; j++){
            if (array[i] == array[j] && array[i] > 0){
                array[i] = 0;
                array[j] = 0;
                flag = 1;
                break;
            }
        }
        if (flag == 1)
            break;
    }
    if (flag == 0)
        return 0;
    else
        return findpair(array, start, end) + 1;
}



int main(){
    int array[] = {11, 5, 7, 9, 11, 3, 11, 5, 11};
    int num = findpair(array, 0, 8);
    printf("%d\n", num);
    return 0;
}
