/**
 * @file kdtree.cpp
 * Implementation of KDTree class.
 */

#include <utility>
#include <algorithm>
#include <iostream>
using namespace std;

template <int Dim>
bool KDTree<Dim>::smallerDimVal(const Point<Dim>& first,
                                const Point<Dim>& second, int curDim) const
{
    /**
     * @todo Implement this function!
     */
    if (first[curDim] != second[curDim])
      return (first[curDim] < second[curDim]);
    else
      return first < second;
}

template <int Dim>
bool KDTree<Dim>::shouldReplace(const Point<Dim>& target,
                                const Point<Dim>& currentBest,
                                const Point<Dim>& potential) const
{
    /**
     * @todo Implement this function!
     */
    // first calculate two distance
    double potential_target = 0;
    double cur_target = 0;
    for (int i = 0; i < Dim; i++){
      potential_target += (potential[i]-target[i]) * (potential[i]-target[i]);
      cur_target += (currentBest[i]-target[i]) * (currentBest[i]-target[i]);
    }
    if (potential_target != cur_target)
      return potential_target < cur_target;
    else
      return potential < currentBest;
}


// swap the value of v[i1] and v[i2]
template <int Dim>
void swap(vector<Point<Dim>>& v, int i1, int i2){
    Point<Dim> temp = v[i1];
    v[i1] = v[i2];
    v[i2] = temp;
}

// this helper function takes last element as pivot
// place the pivot element at its correct position
// place all elements smaller than it to its left and ones larger than it to the right
template <int Dim>
int KDTree<Dim>::partition(vector<Point<Dim>>& v, int low, int high, int levels)
{
    Point<Dim> pivot = v[high];
    int i = low - 1;
    for (int j = low; j < high; j++){
      if (smallerDimVal(v[j], pivot, levels)){
        i++;
        swap(v, i, j);
      }
    }
    swap(v, i+1, high);
    return i+1;
}

// in this helper function, I will sort the vector input using quicksort algorithm
// and find the median point of the vector.
// input levels indicates the comparison levels of the point. levels can be either 0, 1 or 2
template <int Dim>
void KDTree<Dim>::quicksort(vector<Point<Dim>>& input, int low, int high, int levels)
{
    if (low < high){
      // pivot is the partition index
      int pivot = partition(input, low, high, levels);
      // do recursive quicksort
      quicksort(input, low, pivot-1, levels);
      quicksort(input, pivot+1, high, levels);
    }
}

// template <int Dim>
// void KDTree<Dim>::construct(KDTreeNode*& root, vector<Point<Dim>>& input, int levels)
// {
//     // if the vector is empty, no node needs to be added
//     if (input.empty())
//       return;
//     quicksort(input, 0, input.size()-1, levels);
//     // find the median
//     size_t median = (input.size()-1)/2;
//     root = new KDTreeNode(input[median]);
//     vector<Point<Dim>> left, right;
//     // cout << "reach 0" << endl;
//     // left vector store the points "less" than the pivot
//     // and right vector stores the points "larger" than pivot
//     for (size_t i = 0; i < input.size(); i++){
//       if (i == median) continue;
//       if (i < median) left.push_back(input[i]);
//       else right.push_back(input[i]);
//     }
//     construct(root->left, left, (levels+1)%Dim);
//     construct(root->right, right, (levels+1)%Dim);
// }

template <int Dim>
typename KDTree<Dim>::KDTreeNode* KDTree<Dim>::construct(vector<Point<Dim>>& input, int levels)
{
    // if the vector is empty, no node needs to be added
    if (input.empty())
      return NULL;
    quicksort(input, 0, input.size()-1, levels);
    // find the median
    size_t median = (input.size()-1)/2;
    KDTreeNode* root = new KDTreeNode(input[median]);
    vector<Point<Dim>> left, right;
    // cout << "reach 0" << endl;
    // left vector store the points "less" than the pivot
    // and right vector stores the points "larger" than pivot
    for (size_t i = 0; i < input.size(); i++){
      if (i == median) continue;
      if (i < median) left.push_back(input[i]);
      else right.push_back(input[i]);
    }
    root->left = construct(left, (levels+1)%Dim);
    root->right = construct(right, (levels+1)%Dim);
    return root;
}




template <int Dim>
KDTree<Dim>::KDTree(const vector<Point<Dim>>& newPoints)
{
    /**
     * @todo Implement this function!
     */
    // To construct the tree, we first need to create a root
    // then we need to separate the node into two groups as the L, R subtree
    // this requires us to first sort the vector and then choose the median Point and set the point as a partition
    size = newPoints.size();
    root = NULL;
    if (size == 0){
      return;
    }
    vector<Point<Dim>> input;
    for (size_t i = 0; i < newPoints.size(); i++){
      input.push_back(newPoints[i]);
    }
    // construct(root, input, 0);
    root = construct(input, 0);
}



template <int Dim>
KDTree<Dim>::KDTree(const KDTree& other) {
  /**
   * @todo Implement this function!
   */
   size = other.size;
   root = copy(other.root);
}

template <int Dim>
const KDTree<Dim>& KDTree<Dim>::operator=(const KDTree& rhs) {
  /**
   * @todo Implement this function!
   */
  if (this != &rhs){
    clear(root);
    root = copy(rhs.root);
    size = rhs.size;
  }
  return *this;
}

// two helper function copy and clear
template <int Dim>
typename KDTree<Dim>::KDTreeNode* KDTree<Dim>::copy(KDTreeNode *root)
{
    if (root == NULL)
      return NULL;

    // copy the tree use in order traversal
    KDTreeNode* node = new KDTreeNode(root->point);
    node->left = copy(root->left);
    node->right = copy(root->right);
    return node;
}

template <int Dim>
void KDTree<Dim>::clear(KDTreeNode* root)
{
    if (root == NULL)
      return;
    clear(root->left);
    clear(root->right);
    delete root;
}



template <int Dim>
KDTree<Dim>::~KDTree() {
  /**
   * @todo Implement this function!
   */
   clear(root);
   size = 0;
}

// calculate the distance between two Points
template <int Dim>
double KDTree<Dim>::distance(const Point<Dim>& first, const Point<Dim>& second) const
{
    double dis = 0;
    for (int i = 0; i < Dim; i++){
      dis += (first[i]-second[i]) * (first[i]-second[i]);
    }
    return dis;
}

template <int Dim>
void KDTree<Dim>::find(const KDTreeNode* root, Point<Dim>& nearest,
  const Point<Dim>& query, double* dis, int levels) const
{
    // find the nearest neighbor use pre-order traverse
    if (root == NULL)
      return;
    find(root->left, nearest, query, dis, (levels+1)%Dim);
    double temp_dis = distance(root->point, query);
    // if distance is smaller for current node, we need to update the nearest
    if (temp_dis < *dis){
      *dis = temp_dis;
      nearest = root->point;
    }
    // if the distance is equal, we need to check whether we need to update the node
    if (temp_dis == *dis){
      if (root->point < nearest)
        nearest = root->point;
    }
    find(root->right, nearest, query, dis, (levels+1)%Dim);
}


template <int Dim>
void KDTree<Dim>::findNN(const KDTreeNode* root, Point<Dim>& nearest,
  const Point<Dim>& query, double* dis, int levels) const
{
    // first, do recursion to find the hyperrectangle that the point lies in
    // two base case
    if (root == NULL){
      // nearest = Point<Dim>();
      return;
    }
    if (root->left == NULL && root->right == NULL){
      *dis = distance(query, root->point);
      nearest = root->point;
      return;
    }
    if (smallerDimVal(query, root->point, levels)){
      findNN(root->left, nearest, query, dis, (levels+1)%Dim);
      // after finding the leaf, we need to compare the distance use backtrack traversal
      /*
      if (distance(query, root->point) <= *dis){
          *dis = distance(query, root->point);
          // if the root->point is nearer that the previous point
          // we need to traverse the other subtree
          find(root, nearest, query, dis, levels);
      }
      */
      if (distance(query, root->point) < *dis){
        *dis = distance(query, root->point);
        nearest = root->point;
        if (root->right != NULL)
          find(root->right, nearest, query, dis, (levels+1)%Dim);
      }
      else if ((query[levels] - (root->point)[levels])*(query[levels] - (root->point)[levels]) <= *dis){
        // // debug use
        // cout << "query is " << query << endl;
        // cout << "root->point is " << root->point << endl;
        // cout << "current nearest is " << nearest << endl;
        // nearest = (nearest < root->point)? nearest : root->point;
        // if (root->right != NULL)
        find(root->right, nearest, query, dis, (levels+1)%Dim);
      }
    }
    else{
      findNN(root->right, nearest, query, dis, (levels+1)%Dim);
      /*
      // after finding the leaf, we need to compare the distance use backtrack traversal
      if (distance(query, root->point) <= *dis){
          *dis = distance(query, root->point);
          // if the root->point is nearer that the previous point
          // we need to traverse the other subtree
          find(root, nearest, query, dis, levels);
      }
      */
      if (distance(query, root->point) < *dis){
        *dis = distance(query, root->point);
        nearest = root->point;
        if (root->left != NULL)
          find(root->left, nearest, query, dis, (levels+1)%Dim);
      }
      else if ((query[levels] - (root->point)[levels])*(query[levels] - (root->point)[levels]) <= *dis){
      // else if (distance(query, root->point) == *dis){
        // // debug use
        // cout << "query is " << query << endl;
        // cout << "root->point is " << root->point << endl;
        // cout << "current nearest is " << nearest << endl;
        // cout << "levels = " << levels << endl;
        // nearest = (nearest < root->point)? nearest : root->point;
        find(root, nearest, query, dis, levels);
      }
    }
    return;
}



template <int Dim>
Point<Dim> KDTree<Dim>::findNearestNeighbor(const Point<Dim>& query) const
{
    /**
     * @todo Implement this function!
     */
    // if (root == NULL){
    //   return Point<Dim>();
    Point<Dim> nearest = Point<Dim>();
    double dis = 10000.0;
    findNN(root, nearest, query, &dis, 0);
    return nearest;

    // return Point<Dim>();
}
