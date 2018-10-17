#include <iostream>
using namespace std;
/**
 * @file list.cpp
 * Doubly Linked List (MP 3).
 */

/**
 * Destroys the current List. This function should ensure that
 * memory does not leak on destruction of a list.
 */
template <class T>
List<T>::~List() {
  /// @todo Graded in MP3.1
  clear();
}

/**
 * Destroys all dynamically allocated memory associated with the current
 * List class.
 */
template <class T>
void List<T>::clear() {
  /// @todo Graded in MP3.1
  while (this->head_ != NULL){
    ListNode* temp = this->head_->next;
    delete this->head_;
    this->head_ = temp;
  }
  this->length_ = 0;
}

/**
 * Inserts a new node at the front of the List.
 * This function **SHOULD** create a new ListNode.
 *
 * @param ndata The data to be inserted.
 */
template <class T>
void List<T>::insertFront(T const & ndata) {
  /// @todo Graded in MP3.1
  ListNode* node = new ListNode(ndata);
  node->prev = NULL;
  if (this->head_ == NULL){
    this->tail_ = node;
    this->head_ = node;
    node->next = NULL;
    this->length_++;
    return;
  }
  // make connections between node and original head_
  node->next = this->head_;
  this->head_->prev = node;
  // change head_
  this->head_ = node;
  this->length_++;
}

/**
 * Inserts a new node at the back of the List.
 * This function **SHOULD** create a new ListNode.
 *
 * @param ndata The data to be inserted.
 */
template <class T>
void List<T>::insertBack(const T & ndata) {
  /// @todo Graded in MP3.1
  ListNode* node = new ListNode(ndata);
  node->next = NULL;
  if (this->tail_ == NULL){
    this->tail_ = node;
    this->head_ = node;
    node->prev = NULL;
    this->length_++;
    return;
  }
  node->prev = this->tail_;
  this->tail_->next = node;
  this->tail_ = node;
  this->length_++;
}

/**
 * Reverses the current List.
 */
template <class T>
void List<T>::reverse() {
  reverse(head_, tail_);
}

/**
 * Helper function to reverse a sequence of linked memory inside a List,
 * starting at startPoint and ending at endPoint. You are responsible for
 * updating startPoint and endPoint to point to the new starting and ending
 * points of the rearranged sequence of linked memory in question.
 *
 * @param startPoint A pointer reference to the first node in the sequence
 *  to be reversed.
 * @param endPoint A pointer reference to the last node in the sequence to
 *  be reversed.
 */
template <class T>
void List<T>::reverse(ListNode *& startPoint, ListNode *& endPoint) {
  // cout << head_ << "," << tail_ << endl;
  /// @todo Graded in MP3.1
  // case 1: this is no node or only one node
  if (startPoint == endPoint)
    return;

  ListNode *temp;
  ListNode *temp1 = startPoint->prev;
  ListNode *temp2 = endPoint->next;
  // first change all the internal node direction
  ListNode *cur = startPoint;

  while (cur != temp2){
    temp = cur->next;
    cur->next = cur->prev;
    cur->prev = temp;
    if (cur != NULL)
      cur = cur->prev;
  }

  // second, change the first and last elements' pointer in the sublist
  startPoint->next = temp2;
  endPoint->prev = temp1;
  // if startPoint is the head_
  if (startPoint == this->head_ && endPoint != this->tail_){
    // cout << "1. h & t " << head_ << " " << tail_ << endl;
    // cout << "   s & e " << startPoint << " " << endPoint << endl;

    // set breakpoint
    temp = endPoint;
    endPoint = startPoint;
    startPoint = temp;
    // change the head_ pointer
    head_ = startPoint;
    // change the interconnection between nodes
    temp2->prev = endPoint;

    // cout << "2. h & t " << head_ << " " << tail_ << endl;
    // cout << "   s & e " << startPoint << " " << endPoint << endl;
    // set breakpoint
  }
  // if endPoint is the tail_
  else if (endPoint == this->tail_ && startPoint != this->head_){
    temp = startPoint;
    startPoint = endPoint;
    endPoint = temp;
    // change the tail_ pointer
    tail_ = endPoint;
    // change the interconnection between nodes
    temp1->next = startPoint;

  }
  // if startPoint is head_ and endPoint is tail_
  else if (startPoint == this->head_ && endPoint == this->tail_){
    temp = startPoint;
    startPoint = endPoint;
    endPoint = temp;
    // change the head_ and tail_ pointers
    head_ = startPoint;
    tail_ = endPoint;
  }
  // if startPoint is not head_ and endPoint is not tail_
  else{
    temp = startPoint;
    startPoint = endPoint;
    endPoint = temp;
    temp1->next = startPoint;
    temp2->prev = endPoint;
  }
}

/**
 * Reverses blocks of size n in the current List. You should use your
 * reverse( ListNode * &, ListNode * & ) helper function in this method!
 *
 * @param n The size of the blocks in the List to be reversed.
 */
template <class T>
void List<T>::reverseNth(int n) {
  /// @todo Graded in MP3.1
  ListNode* startPoint = head_;
  ListNode* endPoint = head_;
  int i;
  while (startPoint != NULL){
    i = 1;
    while (endPoint != tail_ && i < n){
      endPoint = endPoint->next;
      i++;
    }
    reverse(startPoint, endPoint);
    startPoint = endPoint->next;
    endPoint = startPoint;
  }

}

/**
 * Modifies the List using the waterfall algorithm.
 * Every other node (starting from the second one) is removed from the
 * List, but appended at the back, becoming the new tail. This continues
 * until the next thing to be removed is either the tail (**not necessarily
 * the original tail!**) or NULL.  You may **NOT** allocate new ListNodes.
 * Note that since the tail should be continuously updated, some nodes will
 * be moved more than once.
 */

// helper function to remove the node and add this node to the tail_
// node cannot be the head_ of the List
/*
template <class T>
void List<T>::deleteNode(ListNode *& node){
  if (node == tail_)
    return;
  ListNode* pre = node->prev;
  ListNode* aft = node->next;
  // 1. change the tail_
  node->next = NULL;
  node->prev = tail_;
  tail_ = node;
  // 2.  change the prev, next of ListNode* pre and aft
  pre->next = aft;
  aft->prev = pre;
}
*/

template <class T>
void List<T>::waterfall() {
  /// @todo Graded in MP3.1
  if (head_ == NULL || head_->next == NULL)
    return;
  ListNode* cur = head_;
  while (cur->next != NULL){
    // node needs to be placed at the tail_ of the List
    ListNode* node = cur->next;
    if (node == tail_)
      return;
    ListNode* aft = node->next;
    // 1. change the tail_
    node->next = NULL;
    node->prev = tail_;
    tail_->next = node;
    tail_ = node;
    // 2.  change the prev, next of ListNode* pre and aft
    cur->next = aft;
    aft->prev = cur;
    // go to next node
    cur = cur->next;
  }
}

/**
 * Splits the given list into two parts by dividing it at the splitPoint.
 *
 * @param splitPoint Point at which the list should be split into two.
 * @return The second list created from the split.
 */
template <class T>
List<T> List<T>::split(int splitPoint) {
    if (splitPoint > length_)
        return List<T>();

    if (splitPoint < 0)
        splitPoint = 0;

    ListNode * secondHead = split(head_, splitPoint);

    int oldLength = length_;
    if (secondHead == head_) {
        // current list is going to be empty
        head_ = NULL;
        tail_ = NULL;
        length_ = 0;
    } else {
        // set up current list
        tail_ = head_;
        while (tail_ -> next != NULL)
            tail_ = tail_->next;
        length_ = splitPoint;
    }

    // set up the returned list
    List<T> ret;
    ret.head_ = secondHead;
    ret.tail_ = secondHead;
    if (ret.tail_ != NULL) {
        while (ret.tail_->next != NULL)
            ret.tail_ = ret.tail_->next;
    }
    ret.length_ = oldLength - splitPoint;
    return ret;
}

/**
 * Helper function to split a sequence of linked memory at the node
 * splitPoint steps **after** start. In other words, it should disconnect
 * the sequence of linked memory after the given number of nodes, and
 * return a pointer to the starting node of the new sequence of linked
 * memory.
 *
 * This function **SHOULD NOT** create **ANY** new List or ListNode objects!
 *
 * @param start The node to start from.
 * @param splitPoint The number of steps to walk before splitting.
 * @return The starting node of the sequence that was split off.
 */
template <class T>
typename List<T>::ListNode * List<T>::split(ListNode * start, int splitPoint) {
  /// @todo Graded in MP3.2
  // if splitPoint is 0, return all the list after start
  if (splitPoint == 0){
    ListNode* list = start;
    if (start->prev == NULL){
      head_ = NULL;
      return list;
    }
    else{
      ListNode* pre = start->prev;
      pre->next = NULL;
      start->prev = NULL;
      return list;
    }
  }

  // else, return part of the list and modify the origin list
  ListNode* cur = start;
  int flag = 0;
  for (int i = 0; i < splitPoint; i++){
    cur = cur->next;
    if (cur == NULL){
      flag = 1;
      break;
    }
  }
  // if reach the end of the origin list
  if (flag == 1)
    return NULL;
  // else
  ListNode* pre = cur->prev;
  pre->next = NULL;
  cur->prev = NULL;
  return cur;
}

/**
 * Merges the given sorted list into the current sorted list.
 *
 * @param otherList List to be merged into the current list.
 */
template <class T>
void List<T>::mergeWith(List<T> & otherList) {
    // set up the current list
    head_ = merge(head_, otherList.head_);
    tail_ = head_;

    // make sure there is a node in the new list
    if (tail_ != NULL) {
        while (tail_->next != NULL)
            tail_ = tail_->next;
    }
    length_ = length_ + otherList.length_;

    // empty out the parameter list
    otherList.head_ = NULL;
    otherList.tail_ = NULL;
    otherList.length_ = 0;
}

/**
 * Helper function to merge two **sorted** and **independent** sequences of
 * linked memory. The result should be a single sequence that is itself
 * sorted.
 *
 * This function **SHOULD NOT** create **ANY** new List objects.
 *
 * @param first The starting node of the first sequence.
 * @param second The starting node of the second sequence.
 * @return The starting node of the resulting, sorted sequence.
 */
template <class T>
typename List<T>::ListNode * List<T>::merge(ListNode * first, ListNode* second) {
  /// @todo Graded in MP3.2
  if (second == NULL)
    return first;
  if (first == NULL){
    first = second;
    second = NULL;
    return first;
  }
  ListNode* curA = first;
  ListNode* curB = second;
  ListNode* temp;
  // since first and second are sorted list, the head must be headA or headB
  if (curB->data < curA->data){
    temp = curB->next;
    curB->next = curA;
    curA->prev = curB;
    // change the head of A and B
    curA = curB;
    curB = temp;
    first = curA;
    if (curB != NULL)
      curB->prev = NULL;
    // after modifying, curB may become NULL
    if (curB == NULL)
      return first;
  }
  // if curA only has one node, connct curA to the back of curA
  if (curA->next == NULL){
    curA->next = curB;
    curB->prev = curA;
    second = NULL;
    return curA;
  }
  // then, we need to insert each node of B to the proper location in A
  while (curB != NULL){
    if (curB->data < curA->next->data){
      // if data of curB is less than the data of next of A,
      // we need to insert this node in front of curA->next
      temp = curB->next;
      curB->next = curA->next;
      curA->next->prev = curB;
      curA->next = curB;
      curB->prev = curA;
      // change position of curA and curB
      curB = temp;
      // after modifying, curB may become NULL
      if (curB != NULL)
        curB->prev = NULL;
      else
        return first;
    }
    else{
      curA = curA->next;
    }
    if (curA->next == NULL){
      curA->next = curB;
      break;
    }
  }
  second = NULL;
  return first;
}

/**
 * Sorts the current list by applying the Mergesort algorithm.
 */
template <class T>
void List<T>::sort() {
    if (empty())
        return;
    head_ = mergesort(head_, length_);
    tail_ = head_;
    while (tail_->next != NULL)
        tail_ = tail_->next;
}

/**
 * Sorts a chain of linked memory given a start node and a size.
 * This is the recursive helper for the Mergesort algorithm (i.e., this is
 * the divide-and-conquer step).
 *
 * @param start Starting point of the chain.
 * @param chainLength Size of the chain to be sorted.
 * @return A pointer to the beginning of the now sorted chain.
 */
template <class T>
typename List<T>::ListNode* List<T>::mergesort(ListNode * start, int chainLength) {
  /// @todo Graded in MP3.2

  // base case
  if (chainLength == 0 || chainLength == 1)
    return start;
  int lengthA = chainLength / 2;
  int lengthB = chainLength - lengthA;
  // split original list into two small sublist
  ListNode* startA = start;
  ListNode* startB = split(startA, lengthA);
  startA = mergesort(startA, lengthA);
  startB = mergesort(startB, lengthB);
  startA = merge(startA, startB);
  return startA;
}
