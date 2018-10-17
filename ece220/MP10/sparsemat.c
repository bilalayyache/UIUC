#include "sparsemat.h"

#include <stdio.h>
#include <stdlib.h>

/* Introduction
    In this MP, we do operations to sparse matrices.
    Sparse matrix is a matrix which has lots of zeros inside and we only care about the nonzero terms.
    There are 7 functions that need to be completed.
    1. load_tuples. This function takes the input_file and load the input matrix to a linked list.
      This function will also automatic sorted the input data. If there are multiple data related to same row and column
      in matrix, the helper function add_node will deal with this situation. At last, another helper function delete_zero will
      delete all zeros in the linked list and return the numbers of nonzero items in the linked list.

    2. gv_tuples. This function will return the value of a given row and column of a matrix.

    3. set_tuples. This function will set the given node (given value in the matrix) in place.

    4. save_tuples. This function will save the matrix information to a output text file.

    5. add_tuples. This function will compute the result of sum of two matrices and return the result.
      In this function, I have a helper function called addition that helps to derive the result.

    6. mult_tuples. This function will compute the multiplication of two input matrices and return the result.

    7. destroy_tuples. This function will free the allocation for matrices to prevent memory leak.
*/

void add_node(sp_tuples_node **list, int row, int col, double value, int type);
int delete_zero(sp_tuples *mat_t, sp_tuples_node **list);
void addition(sp_tuples * matA, sp_tuples * matB);

sp_tuples * load_tuples(char* input_file)
{
    FILE *file  = fopen(input_file, "r");
    int input_row, input_col;
    double input_val;
    char junk;                  // used to get rid of newline char at the end of each line

    // initialize matrix
    sp_tuples *matrix = (sp_tuples*)malloc(sizeof(sp_tuples));
    fscanf(file, "%d%d%c", &matrix->m, &matrix->n, &junk);
    matrix->nz = 0;
    matrix->tuples_head = NULL;

    // use set_tuples function to set the content in matrix
    while(fscanf(file, "%d%d%lf%c", &input_row, &input_col, &input_val, &junk) != EOF){
        set_tuples(matrix, input_row, input_col, input_val);
    }
    fclose(file);                         // close the file that we read
    return matrix;                        // return the matrix that we made
}



double gv_tuples(sp_tuples * mat_t,int row,int col)

{
    sp_tuples_node * current = mat_t->tuples_head;     // head of matrix
    while ( ((current->row != row) || (current->col != col)) && (current != NULL)){
        current = current->next;                       // if not the wanted value, move to next value
    }
    if (current == NULL)                               // if not found, it must be 0
        return 0;
    else                                               // if found, return the value
        return current->value;
}



void set_tuples(sp_tuples * mat_t, int row, int col, double value)
{
    // we need to put this node in the correct place in the linked list
    sp_tuples_node *head = mat_t->tuples_head;
    // 1. If head don't have any node
    if (head == NULL){
        head = (sp_tuples_node *)malloc(sizeof(sp_tuples_node));
        head->value = value;
        head->row = row;
        head->col = col;
        head->next = NULL;
        mat_t->nz += 1;
        mat_t->tuples_head = head;
        return;
    }
    else
        add_node(&head, row, col, value, 1);
    // at last, we need to get rid of zeros in the matrix
    mat_t->nz = delete_zero(mat_t, &head);
    mat_t->tuples_head = head;
    return;
}

///////////////////////////////////////////////////////////////////////
// Helper Function add_node, which will add a node to the linked list
///////////////////////////////////////////////////////////////////////
void add_node(sp_tuples_node **list, int row, int col, double value, int type)
{
    // if *list is NULL, we must add this node to a empty linked list pointed by list
    if (*list == NULL){
        (*list) = (sp_tuples_node *)malloc(sizeof(sp_tuples_node));
        (*list)->value = value;
        (*list)->row = row;
        (*list)->col = col;
        (*list)->next = NULL;
        return;
    }
    sp_tuples_node *current = *list, *prev = NULL;
    // initialize the new node
    sp_tuples_node *new = (sp_tuples_node *)malloc(sizeof(sp_tuples_node));
    new->value = value;
    new->row = row;
    new->col = col;
    new->next = NULL;
    // there are four cases:
    // 1. add a node at beginning
    // 2. add a node in the middle
    // 3. add a node at the end
    // 4. modify a node (if type = 1, overwrite the value, if type = 2, add the value together)

    // case 1
    if ((row < current->row) || (row == current->row && col < current->col)){
        new->next = current;
        *list = new;
        return;
        //return 1;
    }
    // case 2, 3, 4
    else{
        // case 4
        while (current != NULL){
            if (row == current->row && col == current->col){
                if (type == 1)
                    current->value = value;
                else
                    current->value += value;
                free(new);
                return;
            }
            // case 2, 3
            else if (row < current->row || ((row == current->row) && (col < current->col))){
                break;
            }
            prev = current;
            current = current->next;
        }
        new->next = current;                        // update the pointer to add in a node
        prev->next = new;
        return;
    }
}

///////////////////////////////////////////////////////////////////////
// Helper Function delete_zero, which delete zeros in the linked list
///////////////////////////////////////////////////////////////////////
// input : mat_t, *list points to head of the linked list
// output : # of nonzero values in the matrix
int delete_zero(sp_tuples *mat_t, sp_tuples_node **list)
{
    if ((*list) == NULL)                          // if there is nothing in the matrix, return 0
        return 0;
    int number = 0;
    sp_tuples_node *current = *list;
    sp_tuples_node *prev = current;
    if (current->value == 0.0){                   // if the first element in linked list is 0, use recursion to delete this node
        *list = current->next;
        mat_t->tuples_head = *list;
        free(current);
        return (delete_zero(mat_t, list));
    }
    while (current != NULL){
        if (current->value == 0.0){               // if found a zero, delete this node by change the pointer
            prev->next = current->next;
            free(current);
            current = prev->next;
        }
        else{                                     // if current node is not zero, go to next node
            prev = current;
            current = current->next;
            number += 1;
        }
    }
    return number;                                // return the numbers of nonzero elements in linked list
}


void save_tuples(char * file_name, sp_tuples * mat_t)
{
    sp_tuples_node *current = mat_t->tuples_head;
    FILE *file = fopen(file_name, "w");           // open a file to wirte data
    fprintf(file, "%d %d\n", mat_t->m, mat_t->n);
    int N = mat_t->nz;                            // # of non-zero value
    int i;                                        // index
    for (i = 0; i < N; i++){
        fprintf(file, "%d %d %lf\n", current->row, current->col, current->value);
        current = current->next;
    }

    fclose(file);
    return;
}



// this function calculates matC = matA + matB
sp_tuples * add_tuples(sp_tuples * matA, sp_tuples * matB){
    if ((matA->m != matB->m) || (matA->n != matB->n) || matA == NULL || matB == NULL)   // if size not matched, return NULL
        return NULL;
    sp_tuples * matC = (sp_tuples *)malloc(sizeof(sp_tuples));
    matC->m = matA->m;
    matC->n = matA->n;
    matC->nz = 0;
    matC->tuples_head = NULL;

    addition(matC, matA);                          // use helper function to calculate the sum
    addition(matC, matB);
    matC->nz = delete_zero(matC, &(matC->tuples_head));
    return matC;
}

///////////////////////////////////////////////////////////////////////
// Helper Function addition, which adds two matrix
///////////////////////////////////////////////////////////////////////
// input : matA, matB
// output : no
// effect: update matA to be the result of matA + matB
// algorithm :
// Traverse matB. If element's location in matB appears in matA, sum them up
// If not, add a node to matA.
// in this function, I reused the helper function add_node and set a type to indicate the add type
void addition(sp_tuples * matA, sp_tuples * matB){
    sp_tuples_node *headA = matA->tuples_head;
    sp_tuples_node *currentB = matB->tuples_head;
    while (currentB != NULL){
        add_node(&headA, currentB->row, currentB->col , currentB->value, 2);
        matA->tuples_head = headA;
        currentB = currentB->next;
    }
}


sp_tuples * mult_tuples(sp_tuples * matA, sp_tuples * matB){
    if (matA->n != matB->m || matA == NULL || matB == NULL)             // if size not match, return NULL
        return NULL;
    sp_tuples * matC = (sp_tuples *)malloc(sizeof(sp_tuples));          // initialize matC
    matC->m = matA->m;
    matC->n = matB->n;
    matC->nz = 0;
    matC->tuples_head = NULL;

    sp_tuples_node *currentA = matA->tuples_head;
    sp_tuples_node *currentB = matB->tuples_head;
    sp_tuples_node *headC = matC->tuples_head;

    double value;
    while (currentA != NULL){           // begin traverse matA
        while (currentB != NULL){       // for each matched element in matB, we nned to do the addition
            if (currentB->row == currentA->col){
                value = currentA->value * currentB->value;
                add_node(&headC, currentA->row, currentB->col, value, 2);
            }
            currentB = currentB->next;
        }
        currentA = currentA->next;
        currentB = matB->tuples_head;   // update currentB to be the beginning of matB for next element in matA
    }
    matC->tuples_head = headC;          // return headC to matC
    matC->nz = delete_zero(matC, &(matC->tuples_head));
    return matC;
}


// In this function, we must free all allocated memories, including all nodes in linked list
void destroy_tuples(sp_tuples * mat_t){
    sp_tuples_node *current = mat_t->tuples_head;
    while (current != NULL){              // free all nodes in linked list
        sp_tuples_node *temp = current->next;
        free(current);
        current = temp;
    }
    free(mat_t);                          // free mat_t
    return;
}
