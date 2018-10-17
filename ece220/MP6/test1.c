#include <stdio.h>
#include "updateBoard.h"

int main(){
		int i, j;
		int a[25] = {1,0,1,0,1,
								1,1,0,0,1,
								1,0,0,1,1,
								0,1,1,1,0,
								0,0,0,1,0};
		for (i = 0; i < 5; i++){
				for (j = 0; j < 5; j++){
						printf("%d ", a[i*5+j]);
				}
				printf("\n");
		}
		printf("\n");
		int count;
		for (i = 0; i < 5; i++){
				for (j = 0; j < 5; j++){
						count = countLiveNeighbor(a, 5, 5, i, j);
						printf("%d ", count);
				}
				printf("\n");
		}
		printf("\n");
		updateBoard(a, 5, 5);
		for (i = 0; i < 5; i++){
				for (j = 0; j < 5; j++){
						printf("%d ", a[i*5+j]);
				}
				printf("\n");
		}
		return 0;
}
