/* Your code here! */

#include "dsets.h"


DisjointSets::DisjointSets(){}

// create a disjointset with a certain number of unconnected elements
// num: number of elements of the set
void DisjointSets::addelements(int num)
{
  // add num elements at the back of the vector and set their label to -1
  disjointset_.insert(disjointset_.end(), num, -1);
}

int DisjointSets::find(int elem)
{
  if (disjointset_[elem] < 0)
    return elem;
  // recursive call the function and set the new path after we find the root
  int ret = find(disjointset_[elem]);
  disjointset_[elem] = ret;
  return ret;
}

void DisjointSets::setunion(int a, int b)
{
  int finda = find(a);
  int findb = find(b);
  // smaller set should point to the larger set
  // remember the size is the negative value of the root
  if ((-disjointset_[finda]) < (-disjointset_[findb])){
    disjointset_[findb] += disjointset_[finda];
    disjointset_[finda] = findb;
  }
  else{
    disjointset_[finda] += disjointset_[findb];
    disjointset_[findb] = finda;
  }
}


// this function returns the size of the set that elem belongs to
int DisjointSets::size(int elem)
{
  int find_elem = find(elem);
  return -disjointset_[find_elem];
}

// helper function to clear the disjointset
void DisjointSets::clear()
{
  disjointset_.clear();
}
