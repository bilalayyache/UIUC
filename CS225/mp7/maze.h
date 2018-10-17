/* Your code here! */
#ifndef MAZE_H
#define MAZE_H

#include <vector>
#include <queue>
#include <stack>
#include "cs225/PNG.h"
#include "dsets.h"
using namespace cs225;
using namespace std;

class SquareMaze{
  public:
    SquareMaze();
    void makeMaze(int width, int height);
    bool canTravel(int x, int y, int dir) const;
    void setWall(int x, int y, int dir, bool exists);
    vector<int> solveMaze();
    PNG* drawMaze() const;
    PNG* drawMazeWithSolution();

    // for part 3
    void makeCreativeMaze(int width, int height);
    PNG* drawCreativeMaze() const;
    PNG* drawCreativeMazeWithSolution();


  private:
    int width_;
    int height_;
    int size_;
    DisjointSets disjsets_;
    // vector to store the infomation whether the right wall and down wall exist
    // true if it is wall and false if not
    vector<pair<bool, bool>> cantravel_;


};



#endif
