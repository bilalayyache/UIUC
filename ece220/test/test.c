#include <stdio.h>
#include <stdlib.h>

typedef struct StNode node;

void insert(node **head, int data);
void printlist(node *head);
void deletelist(node *head);

struct StNode{
  int data;
  node* next;
};

int main()
{
  int i;
  int n = 10;
  node *head = NULL;
  for (i = 0; i < n; i++){
    insert(&head, i);
  }
  printlist(head);
  deletelist(head);
  if (head == NULL)
    printf("head is NULL\n");
  else
    printf("head is not NULL\n");
  return 0;
}

void insert(node **head, int data)
{
  node *new = (node*)malloc(sizeof(node));
  new->data = data;
  new->next = *head;
  *head = new;
}

void printlist(node *head)
{
  if (head == NULL)
    return;
  printf("%d\n", head->data);
  printlist(head->next);
}

void deletelist(node *head)
{
  if (head == NULL)
    return;
  node *temp = head;
  head = head->next;
  free(temp);
  deletelist(head);
}
