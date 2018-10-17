/**
 * @file binarytree.cpp
 * Definitions of the binary tree functions you'll be writing for this lab.
 * You'll need to modify this file.
 */
#include "TreeTraversals/InorderTraversal.h"
#include <iostream>
/**
 * @return The height of the binary tree. Recall that the height of a binary
 *  tree is just the length of the longest path from the root to a leaf, and
 *  that the height of an empty tree is -1.
 */
template <typename T>
int BinaryTree<T>::height() const
{
    // Call recursive helper function on root
    return height(root);
}

/**
 * Private helper function for the public height function.
 * @param subRoot
 * @return The height of the subtree
 */
template <typename T>
int BinaryTree<T>::height(const Node* subRoot) const
{
    // Base case
    if (subRoot == NULL)
        return -1;

    // Recursive definition
    return 1 + max(height(subRoot->left), height(subRoot->right));
}

/**
 * Prints out the values of the nodes of a binary tree in order.
 * That is, everything to the left of a node will be printed out before that
 * node itself, and everything to the right of a node will be printed out after
 * that node.
 */
template <typename T>
void BinaryTree<T>::printLeftToRight() const
{
    // Call recursive helper function on the root
    printLeftToRight(root);

    // Finish the line
    cout << endl;
}

/**
 * Private helper function for the public printLeftToRight function.
 * @param subRoot
 */
template <typename T>
void BinaryTree<T>::printLeftToRight(const Node* subRoot) const
{
    // Base case - null node
    if (subRoot == NULL)
        return;

    // Print left subtree
    printLeftToRight(subRoot->left);

    // Print this node
    cout << subRoot->elem << ' ';

    // Print right subtree
    printLeftToRight(subRoot->right);
}


template <typename T>
void BinaryTree<T>::mirror(Node* subroot){
  // in this part, I am going to use the post-order traversal
  // to solve the problem

  // base case
  if (subroot == NULL || (subroot->left == NULL && subroot->right == NULL))
    return;
  mirror(subroot->left);
  mirror(subroot->right);
  Node* temp = subroot->left;
  subroot->left = subroot->right;
  subroot->right = temp;
}

/**
 * Flips the tree over a vertical axis, modifying the tree itself
 *  (not creating a flipped copy).
 */
template <typename T>
void BinaryTree<T>::mirror()
{
    //your code here
    // use helper function mirror(Node*)
    mirror(root);

}

/**
 * isOrdered() function iterative version
 * @return True if an in-order traversal of the tree would produce a
 *  nondecreasing list output values, and false otherwise. This is also the
 *  criterion for a binary tree to be a binary search tree.
 */
template <typename T>
bool BinaryTree<T>::isOrderedIterative() const
{
    // your code here
    // use InorderTraversal to check whether the tree is sorted

    InorderTraversal<T> iot(this->getRoot());
    typename TreeTraversal<T>::Iterator it = iot.begin();
    // while loop

    typename TreeTraversal<T>::Iterator temp = iot.begin();
    ++temp;
    while (temp != iot.end()){
      T t1 = (*it)->elem;
      T t2 = (*temp)->elem;
      if (t2 < t1)
        return false;
      ++it;
      ++temp;
    }
    return true;


    // for loop
    /*
  	for (typename TreeTraversal<T>::Iterator it = iot.begin(); it != iot.end(); ++it) {
      typename TreeTraversal<T>::Iterator temp = it;
      ++temp;
      if (temp != iot.end()){
        if ((*temp)->elem < (*it)->elem)
          return false;
      }
  	}
    return true;
    */
}

// helper function to do recursive isOrdered
// has one input subroot
// if a subtree rooted at subroot is ordered, return ture
template <typename T>
bool BinaryTree<T>::isOrderedRecursive(Node* subroot) const{
    // base case
    if (subroot == NULL || (subroot->left == NULL && subroot->right == NULL))
      return true;
    if (subroot->left != NULL && (subroot->elem < subroot->left->elem))
      return false;
    if (subroot->right != NULL && (subroot->right->elem < subroot->elem))
      return false;
    // recursive case
    return isOrderedRecursive(subroot->left) & isOrderedRecursive(subroot->right);
}


/**
 * isOrdered() function recursive version
 * @return True if an in-order traversal of the tree would produce a
 *  nondecreasing list output values, and false otherwise. This is also the
 *  criterion for a binary tree to be a binary search tree.
 */
template <typename T>
bool BinaryTree<T>::isOrderedRecursive() const
{

    // your code here
    // base case
    return isOrderedRecursive(this->getRoot());
}


template <typename T>
void BinaryTree<T>::printPaths(vector<vector<T> > &paths, Node* subroot, vector<T> temp) const{
    // base case
    if (subroot == NULL)
      return;
    // if current root is not NULL, push this element onto temp
    temp.push_back(subroot->elem);
    if (subroot->left == NULL && subroot->right == NULL){
      paths.push_back(temp);
      // do backtrack, pop the last element and goto the next path
      temp.pop_back();
    }
    // recursion case
    printPaths(paths, subroot->left, temp);
    printPaths(paths, subroot->right, temp);
    // do backtrack, pop the last element and goto the next path
    //temp.pop_back();

}


/**
 * creates vectors of all the possible paths from the root of the tree to any leaf
 * node and adds it to another vector.
 * Path is, all sequences starting at the root node and continuing
 * downwards, ending at a leaf node. Paths ending in a left node should be
 * added before paths ending in a node further to the right.
 * @param paths vector of vectors that contains path of nodes
 */
template <typename T>
void BinaryTree<T>::printPaths(vector<vector<T> > &paths) const
{
    vector<T> temp;
    // your code here
    printPaths(paths, root, temp);
}

template <typename T>
int BinaryTree<T>::sumDistances(Node* subroot) const{
    // base case
    if (subroot == NULL)
      return 0;
    if (subroot->left == NULL && subroot->right == NULL)
      return 0;
    return sumDistances(subroot->left) + sumDistances(subroot->right) +
            NumberofNode(subroot->left) + NumberofNode(subroot->right);
}

template <typename T>
int BinaryTree<T>::NumberofNode(Node* subroot) const{
    if (subroot == NULL)
      return 0;
    if (subroot->left == NULL && subroot->right == NULL)
      return 1;
    return NumberofNode(subroot->left) + NumberofNode(subroot->right) + 1;
}

/**
 * Each node in a tree has a distance from the root node - the depth of that
 * node, or the number of edges along the path from that node to the root. This
 * function returns the sum of the distances of all nodes to the root node (the
 * sum of the depths of all the nodes). Your solution should take O(n) time,
 * where n is the number of nodes in the tree.
 * @return The sum of the distances of all nodes to the root
 */
template <typename T>
int BinaryTree<T>::sumDistances() const
{
    if (root == NULL)
      return -1;
    return sumDistances(root);
}
