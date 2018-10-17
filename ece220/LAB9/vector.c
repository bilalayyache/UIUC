#include "vector.h"
#include <stdlib.h>

// allocate memory location to struct vector and array in the vector struct
vector_t * createVector(int initialSize)
{
  vector_t * vector = (vector_t *)malloc(sizeof(vector_t));
  vector->size = 0;
  vector->maxSize = initialSize;
  vector->array = (int *)malloc(sizeof(int) * initialSize);
  return vector;
}

//  free the memory space for array and vector
void destroyVector(vector_t * vector)
{
  free(vector->array);
  free(vector);
  vector = NULL;
}

// expand the maxSize of array to twice as it was
void resize(vector_t * vector)
{
  vector->maxSize = 2 * vector->maxSize;
  vector->array = (int *)realloc(vector->array, vector->maxSize);
}

// push a number onto array of the vector
void push_back(vector_t * vector, int element)
{
  if (vector->size == vector->maxSize)
    resize(vector);
  vector->array[vector->size] = element;
  vector->size += 1;
}

// pop a number from vector
int pop_back(vector_t * vector)
{
  if (vector->size == 0)
    return 0;
  vector->size -= 1;
  return vector->array[vector->size];
}

// access a member from vector
int access(vector_t * vector, int index)
{
  if (index > vector->size)
    return 0;
  return vector->array[index];
}
