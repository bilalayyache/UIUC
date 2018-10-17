/**
 * @file avltree.cpp
 * Definitions of the binary tree functions you'll be writing for this lab.
 * You'll need to modify this file.
 */
#include <algorithm> // function max
#include <stack>
#include <queue>
#include <cmath>
#include "avltree.h"

using namespace std;

template <class K, class V>
V AVLTree<K, V>::find(const K& key) const
{
    return find(root, key);
}

template <class K, class V>
V AVLTree<K, V>::find(Node* subtree, const K& key) const
{
    if (subtree == NULL)
        return V();
    else if (key == subtree->key)
        return subtree->value;
    else {
        if (key < subtree->key)
            return find(subtree->left, key);
        else
            return find(subtree->right, key);
    }
}

template <class K, class V>
void AVLTree<K, V>::rotateLeft(Node*& t)
{
    functionCalls.push_back("rotateLeft"); // Stores the rotation name (don't remove this)
    // your code here
    if (t != NULL && t->right != NULL){
      Node* node1 = t;
      Node* node2 = t->right;
      Node* B = node2->left;
      // change the root pointer
      t = node2;
      t->left = node1;
      t->left->right = B;
    }

}

template <class K, class V>
void AVLTree<K, V>::rotateLeftRight(Node*& t)
{
    functionCalls.push_back("rotateLeftRight"); // Stores the rotation name (don't remove this)
    // Implemented for you:
    rotateLeft(t->left);
    rotateRight(t);
}

template <class K, class V>
void AVLTree<K, V>::rotateRight(Node*& t)
{
    functionCalls.push_back("rotateRight"); // Stores the rotation name (don't remove this)
    // your code here
    // before rotate and after rotate
    //              parent                   parent
    //               /                        /
    //             node1 (t)                node2 (t)
    //           /      \                  /     \
    //        node2      A              node3   node1
    //        /   \                     /   \   /   \
    //     node3  B                    C    D  B    A
    //     /   \
    //    C    D
    if (t != NULL && t->left != NULL){
      Node* node1 = t;
      Node* node2 = t->left;
      Node* B = node2->right;
      // change the root pointer
      t = node2;
      t->right = node1;
      t->right->left = B;
    }
}

template <class K, class V>
void AVLTree<K, V>::rotateRightLeft(Node*& t)
{
    functionCalls.push_back("rotateRightLeft"); // Stores the rotation name (don't remove this)
    // your code here
    rotateRight(t->right);
    rotateLeft(t);
}

template <class K, class V>
void AVLTree<K, V>::rebalance(Node*& subtree)
{
    // your code here
    if (subtree == NULL)
      return;
    // four cases
    // 1. right rotate
    int balance = BalanceNumber(subtree);
    // adjust the tree
    if (fabs(balance) >= 2){
      // if right subtree is heavier
      if (balance > 0){
        if (BalanceNumber(subtree->right) >= 0)
          rotateLeft(subtree);
        else
          rotateRightLeft(subtree);
      }
      else{
        if (BalanceNumber(subtree->left) <= 0)
          rotateRight(subtree);
        else
          rotateLeftRight(subtree);
      }
    }
}

template <class K, class V>
int AVLTree<K, V>::getHeight(Node* subroot){
  if (subroot == NULL)
    return -1;
  return max(getHeight(subroot->left), getHeight(subroot->right)) + 1;
}

template <class K, class V>
void AVLTree<K, V>::setHeight(Node* subroot){
  if (subroot == NULL)
    return;
  subroot->height = getHeight(subroot);
  setHeight(subroot->left);
  setHeight(subroot->right);
}

template <class K, class V>
int AVLTree<K, V>::BalanceNumber(Node*& node) const{
  return heightOrNeg1(node->right) - heightOrNeg1(node->left);
}

template <class K, class V>
void AVLTree<K, V>::insert(const K & key, const V & value)
{
    insert(root, key, value);
}

template <class K, class V>
void AVLTree<K, V>::insert(Node*& subtree, const K& key, const V& value)
{
    // your code here
    if (subtree == NULL){
      subtree = new Node(key, value);
      return;
    }
    // if the key exist in the tree, replace the value, else create the new Node
    else if (subtree->key == key){
      subtree->value = value;
      return;
    }
    else{
      if (key < subtree->key)
        insert(subtree->left, key, value);
      else
        insert(subtree->right, key, value);
      setHeight(subtree);
      rebalance(subtree);
      setHeight(subtree);
    }

}

template <class K, class V>
void AVLTree<K, V>::remove(const K& key)
{
    remove(root, key);
}

template <class K, class V>
void AVLTree<K, V>::remove(Node*& subtree, const K& key)
{
    if (subtree == NULL)
        return;

    if (key < subtree->key) {
        // your code here
        remove(subtree->left, key);
    } else if (key > subtree->key) {
        // your code here
        remove(subtree->right, key);
    } else {
        if (subtree->left == NULL && subtree->right == NULL) {
            /* no-child remove */
            // your code here
            delete subtree;
            subtree = NULL;
        } else if (subtree->left != NULL && subtree->right != NULL) {
            /* two-child remove */
            // your code here
            // first, we need to find the IOP
            Node* IOP = subtree->left;
            Node* temp;
            while (IOP->right != NULL){
              temp = IOP;
              IOP = IOP->right;
            }
            swap(IOP, subtree);
            // if IOP has no child
            if (IOP->left == NULL){
              delete IOP;
              IOP = NULL;
              temp->right = NULL;
            }
            // IOP has one child
            else{
              temp = IOP;
              IOP = IOP->left;
              delete temp;
              temp = NULL;
            }
        } else {
            /* one-child remove */
            // your code here
            if (subtree->left != NULL){
              Node* temp = subtree;
              subtree = subtree->left;
              delete temp;
            }
            else{
              Node* temp = subtree;
              subtree = subtree->right;
              delete temp;
            }

        }
        // your code here
    }
    // after delete a node, we need to check whether the tree is still balanced
    setHeight(subtree);
    rebalance(subtree);
    setHeight(subtree);
}
