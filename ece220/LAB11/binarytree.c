/**********************
 *  binarytree.c:
 ************************/
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "binarytree.h"

NODE* new_node()
{
	return ((NODE*)malloc(sizeof(NODE)));
}

NODE* init_node(int d1, NODE* p1, NODE* p2)
{
	NODE* t;

	t = new_node();
	t->d = d1;
	t->left = p1;
	t->right = p2;
	return t;
}



void insert_node( int d1, NODE* p1 ){
	if( p1->d < d1 && p1->right == NULL )
		p1->right = init_node( d1, NULL, NULL );
	else if( p1->d > d1 && p1->left == NULL )
		p1->left = init_node( d1, NULL, NULL );
	else if( p1->d < d1 && p1->right != NULL )
		insert_node( d1, p1->right );
	else
		insert_node( d1, p1->left );
}


/* create a binary search tree from an array */
NODE* create_tree(int a[], int size )
{
	int i ;
	NODE* root = init_node( a[0] , NULL , NULL );

	for( i = 1 ; i < size ; i ++ )
		insert_node( a[i] , root  );

	return root;
}

/* find lowest common ancestor of two numbers  */
/*
Algorithm
	To find the ancestor of two input number, the lca must be the number that in between
	first number and second number. Therefore, we only need to traverse the tree until we find the NODE
	the correct node.
*/
NODE* lowest_common_ancestor (NODE* root , int first_number , int second_number )
{
	/* your code goes here */
	// base case
	// first find out the small and large input
	int small_number, large_number;
	small_number = (first_number < second_number) ? first_number : second_number;
	large_number = (first_number > second_number) ? first_number : second_number;
	if (root->d > small_number && root->d < large_number){
		return root;
	}

	// recursion case
	if (root->d > large_number)
		return lowest_common_ancestor(root->left, first_number, second_number);
	else
		return lowest_common_ancestor(root->right, first_number, second_number);
}
