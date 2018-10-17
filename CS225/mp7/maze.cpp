/* Your code here! */
#include "maze.h"
#include <iostream>
#include <cstdlib>
using namespace std;

SquareMaze::SquareMaze()
{
  width_ = 0;
  height_ = 0;
  size_ = 0;
  disjsets_.addelements(0);
}

void SquareMaze::makeMaze(int width, int height)
{
    width_ = width;
    height_ = height;
    size_ = width_ * height_;
    disjsets_.clear();
    disjsets_.addelements(size_);
    cantravel_.clear();
    for (int i = 0; i < size_; i++){
      cantravel_.push_back(make_pair(false, false));
    }
    // make the maze by deleting walls w/o having cycles
    int count = 0;
    while (count < size_){
      int cur = rand() % size_;
      int flag = 0;
      if ((cur+1)%width_ != 0 && disjsets_.find(cur) != disjsets_.find(cur+1)){
        disjsets_.setunion(cur, cur+1);
        cantravel_[cur].first = true;
        flag = 1;
      }
      if (cur < (height_-1)*width_ && disjsets_.find(cur) != disjsets_.find(cur+width_)){
        disjsets_.setunion(cur, cur+width_);
        cantravel_[cur].second = true;
        flag = 1;
      }
      if (flag)
        count++;
      if (count > size_/2){
        break;
      }
    }
    for (int i = 0; i < size_; i++){
      if ((i+1)%width_ != 0 && disjsets_.find(i) != disjsets_.find(i+1)){
        disjsets_.setunion(i, i+1);
        cantravel_[i].first = true;
      }
      if (i < (height_-1)*width_ && disjsets_.find(i) != disjsets_.find(i+width_)){
        disjsets_.setunion(i, i+width_);
        cantravel_[i].second = true;
      }
    }
    // check if all cells are connected
    // for (int i = 0; i < size_; i++){
    //   int j = disjsets_.find(i);
    // }
    // for (int i = 0; i < size_; i++){
    //   cout << disjsets_.find(i) << endl;
    // }
}

bool SquareMaze::canTravel(int x, int y, int dir) const
{
  // first check boundary
  if (y == 0 && dir == 3)
    return false;
  if (x == 0 && dir == 2)
    return false;
  // right
  if (dir == 0)
    return cantravel_[x+y*width_].first;
  // down
  else if (dir == 1)
    return cantravel_[x+y*width_].second;
  // left
  else if (dir == 2)
    return cantravel_[(x-1)+y*width_].first;
  // up
  else
    return cantravel_[x+(y-1)*width_].second;
}

void SquareMaze::setWall(int x, int y, int dir, bool exists)
{
  // set right wall
  if (dir == 0){
      cantravel_[x+y*width_].first = !exists;
  }
  else{
      cantravel_[x+y*width_].second = !exists;
  }
}

vector<int> SquareMaze::solveMaze()
{
  // set a vector to store the distance for each point in the maze to the start point
  vector<int> distance;
  distance.assign(size_, 0);
  // set another vector to store the predecessor for the current point travelled fro start
  vector<int> predecessor;
  predecessor.assign(size_, 0);
  predecessor[0] = -1;
  // use BFS to find the distance for all point
  queue<int> q;
  q.push(0);
  while (!q.empty()){
    int cur = q.front();
    q.pop();
    // find the x, y coordinate of the current point
    int x = cur % width_;
    int y = (cur-x)/width_;

    // debug
    // cout << cur << " " << x << " " << y << endl;
    // cout << canTravel(x, y, 0) << " " << canTravel(x, y, 1) << " " << canTravel(x, y, 2) << " " << canTravel(x, y, 3) << endl;
    // cout << q.size() << endl;
    // if can travel toward right
    if (canTravel(x, y, 0)){
      if (distance[x+1+y*width_] == 0){
        q.push((x+1+y*width_));
        distance[x+1+y*width_] = distance[cur]+1;
        predecessor[x+1+y*width_] = 0;
      }
    }
    // if can travel down
    if (canTravel(x, y, 1)){
      if (distance[x+(1+y)*width_] == 0){
        q.push((x+(y+1)*width_));
        distance[x+(1+y)*width_] = distance[cur]+1;
        predecessor[x+(1+y)*width_] = 1;
      }
    }
    // if can travel left
    if (canTravel(x, y, 2)){
      if (distance[x-1+y*width_] == 0 && x-1+y != 0){
        q.push((x-1+y*width_));
        distance[x-1+y*width_] = distance[cur]+1;
        predecessor[x-1+y*width_] = 2;
      }
    }
    // if can travel up
    if (canTravel(x, y, 3)){
      if (distance[x+(y-1)*width_] == 0 && x+y-1 != 0){
        q.push((x+(y-1)*width_));
        distance[x+(y-1)*width_] = distance[cur]+1;
        predecessor[x+(y-1)*width_] = 3;
      }
    }
  }
  // after traverse, we need to find the max distance for the last row
  int max = 0;
  int max_location = 0;
  for (int i = 0; i < width_; i++){
    if (distance[(height_-1)*width_+i] > max){
      max_location = i;
      max = distance[(height_-1)*width_+i];
    }
  }
  // after finding the location, we need to record the path
  int x_path = max_location;
  int y_path = height_ - 1;
  vector<int> path;
  int step = predecessor[x_path + y_path*width_];
  while (step != -1){
    path.insert(path.begin(), step);
    if (step == 0)
      x_path--;
    else if (step == 1)
      y_path--;
    else if (step == 2)
      x_path++;
    else
      y_path++;
    step = predecessor[x_path + y_path*width_];
    // cout << x_path << " " << y_path << endl;
    // cout << predecessor[x_path + y_path*width_] << endl;
  }
  return path;
}



PNG* SquareMaze::drawMaze() const
{
  PNG* maze = new PNG(width_*10+1, height_*10+1);
  // set topmost and leftmost walls
  // (1, 0) through (9, 0) are entrance and set them to white
  for (unsigned i = 0; i < maze->width(); i++){
    if (i >= 1 && i <= 9)
      continue;
    HSLAPixel& pixel = maze->getPixel(i, 0);
    pixel.a = 1; pixel.l = 0;
  }
  for (unsigned i = 0; i < maze->height(); i++){
    HSLAPixel& pixel = maze->getPixel(0, i);
    pixel.a = 1; pixel.l = 0;
  }

  // draw walls
  for (int x = 0; x < width_; x++){
    for (int y = 0; y < height_; y++){
      if (!canTravel(x, y, 0)){
        // set right wall
        for (int k = 0; k <= 10; k++){
          HSLAPixel& pixel = maze->getPixel((x+1)*10, y*10+k);
          pixel.a = 1; pixel.l = 0;
        }
      }
      if (!canTravel(x, y, 1)){
        // set down wall
        for (int k = 0; k <= 10; k++){
          HSLAPixel& pixel = maze->getPixel(x*10+k, (y+1)*10);
          pixel.a = 1; pixel.l = 0;
        }
      }
    }
  }

  // for (unsigned i = 0; i < maze->width(); i++){
  //   for (unsigned j = 0; j < maze->height(); j++){
  //     HSLAPixel& pixel = maze->getPixel(i, j);
  //     pixel.l = 0;
  //     pixel.a = 1;
  //   }
  // }
  return maze;
}

PNG* SquareMaze::drawMazeWithSolution()
{
  PNG* maze = drawMaze();
  vector<int> solution = solveMaze();
  int x = 0;
  int y = 0;
  for (size_t i = 0; i < solution.size(); i++){
    if (solution[i] == 0){
      for (int k = 0; k <= 10; k++){
        HSLAPixel& pixel = maze->getPixel(x*10+5+k, y*10+5);
        pixel.h = 0; pixel.s = 1; pixel.l = 0.5; pixel.a = 1;
      }
      x++;
    }
    else if (solution[i] == 1){
      for (int k = 0; k <= 10; k++){
        HSLAPixel& pixel = maze->getPixel(x*10+5, y*10+5+k);
        pixel.h = 0; pixel.s = 1; pixel.l = 0.5; pixel.a = 1;
      }
      y++;
    }
    // left
    else if (solution[i] == 2){
      for (int k = 0; k <= 10; k++){
        HSLAPixel& pixel = maze->getPixel(x*10+5-k, y*10+5);
        pixel.h = 0; pixel.s = 1; pixel.l = 0.5; pixel.a = 1;
      }
      x--;
    }
    // up
    else{
      for (int k = 0; k <= 10; k++){
        HSLAPixel& pixel = maze->getPixel(x*10+5, y*10+5-k);
        pixel.h = 0; pixel.s = 1; pixel.l = 0.5; pixel.a = 1;
      }
      y--;
    }
  }
  for (int k = 1; k < 10; k++){
    HSLAPixel& pixel = maze->getPixel(x*10+k, (y+1)*10);
    pixel.h = 0; pixel.s = 0; pixel.l = 1; pixel.a = 1;
  }
  return maze;
}

// for part 3
void SquareMaze::makeCreativeMaze(int width, int height)
{
    width_ = width;
    height_ = height;
    size_ = width_ * height_;
    disjsets_.clear();
    disjsets_.addelements(size_);
    cantravel_.clear();
    for (int i = 0; i < size_; i++){
      cantravel_.push_back(make_pair(false, false));
    }
    int h1 = height_/5;
    int h2 = height_ - 2*h1;
    int w1 = width_/3;
    int w2 = width_ - 2*w1;
    // total number of cell we need to care about
    int number = 2*h1*width_ + h2*w2;
    // make the maze by deleting walls w/o having cycles
    int count = 0;
    while (count < number){
      int cur = rand() % size_;
      int x = cur % width_;
      int y = (cur-x)/width_;
      int flag = 0;
      // right wall
      if (y<h1 || y>=h1+h2 || (x>=w1 && x<w1+w2)){
        if (!((x+1) == width_ || ((x+1) == w1+w2 && y<h1+h2 && y>=h1)) && disjsets_.find(cur) != disjsets_.find(cur+1)){
          disjsets_.setunion(cur, cur+1);
          cantravel_[cur].first = true;
          flag = 1;
        }
      }
      // down wall
      if (y<h1 || y>=h1+h2 || (x>=w1 && x<w1+w2)){
        if (!(y+1 == height_ || (y+1 == h1 && (x<w1 || x>=w1+w2))) && disjsets_.find(cur) != disjsets_.find(cur+width_)){
          disjsets_.setunion(cur, cur+width_);
          cantravel_[cur].second = true;
          flag = 1;
        }
      }
      // if (cur < (height_-1)*width_ && disjsets_.find(cur) != disjsets_.find(cur+width_)){
      //   disjsets_.setunion(cur, cur+width_);
      //   cantravel_[cur].second = true;
      //   flag = 1;
      // }
      if (flag)
        count++;
      if (count > number/2){
        break;
      }
      // cout << count << endl;
    }
    for (int i = 0; i < size_; i++){
      int x = i % width_;
      int y = (i-x)/width_;
      if (y<h1 || y>=h1+h2 || (x>=w1 && x<w1+w2)){
        if (!((x+1) == width_ || ((x+1) == w1+w2 && y<h1+h2 && y>=h1)) && disjsets_.find(i) != disjsets_.find(i+1)){
          disjsets_.setunion(i, i+1);
          cantravel_[i].first = true;
        }
        if (!(y+1 == height_ || (y+1 == h1 && (x<w1 || x>=w1+w2))) && disjsets_.find(i) != disjsets_.find(i+width_)){
          disjsets_.setunion(i, i+width_);
          cantravel_[i].second = true;
        }
      }
    }
}


PNG* SquareMaze::drawCreativeMaze() const
{
  PNG* maze = new PNG(width_*10+1, height_*10+1);
  // set topmost and leftmost walls
  // (1, 0) through (9, 0) are entrance and set them to white
  int h1 = height_/5;
  int h2 = height_ - 2*h1;
  int w1 = width_/3;
  int w2 = width_ - 2*w1;
  for (unsigned i = 0; i < maze->width(); i++){
    if (i >= 1 && i <= 9)
      continue;
    HSLAPixel& pixel = maze->getPixel(i, 0);
    pixel.a = 1; pixel.l = 0;
  }
  for (unsigned i = 0; i < maze->height(); i++){
    HSLAPixel& pixel = maze->getPixel(0, i);
    pixel.a = 1; pixel.l = 0;
  }

  // draw walls
  for (int x = 0; x < width_; x++){
    for (int y = 0; y < height_; y++){
      if (!canTravel(x, y, 0)){
        // set right wall
        for (int k = 0; k <= 10; k++){
          HSLAPixel& pixel = maze->getPixel((x+1)*10, y*10+k);
          pixel.a = 1; pixel.l = 0;
        }
      }
      if (!canTravel(x, y, 1)){
        // set down wall
        for (int k = 0; k <= 10; k++){
          HSLAPixel& pixel = maze->getPixel(x*10+k, (y+1)*10);
          pixel.a = 1; pixel.l = 0;
        }
      }
    }
  }
  // ignore the part does not belong to maze
  for (int x = 0; x < int(maze->width()); x++){
    for (int y = 0; y < int(maze->height()); y++){
      if ((x<10*w1 || x>10*(w1+w2)) && y>10*h1 && y<10*(h1+h2)){
        HSLAPixel& pixel = maze->getPixel(x, y);
        pixel.h = 0; pixel.s = 0; pixel.l = 0; pixel.a = 0;
      }
    }
  }
  return maze;
}

PNG* SquareMaze::drawCreativeMazeWithSolution()
{
  PNG* maze = drawCreativeMaze();
  vector<int> solution = solveMaze();
  int x = 0;
  int y = 0;
  for (size_t i = 0; i < solution.size(); i++){
    if (solution[i] == 0){
      for (int k = 0; k <= 10; k++){
        HSLAPixel& pixel = maze->getPixel(x*10+5+k, y*10+5);
        pixel.h = 0; pixel.s = 1; pixel.l = 0.5; pixel.a = 1;
      }
      x++;
    }
    else if (solution[i] == 1){
      for (int k = 0; k <= 10; k++){
        HSLAPixel& pixel = maze->getPixel(x*10+5, y*10+5+k);
        pixel.h = 0; pixel.s = 1; pixel.l = 0.5; pixel.a = 1;
      }
      y++;
    }
    // left
    else if (solution[i] == 2){
      for (int k = 0; k <= 10; k++){
        HSLAPixel& pixel = maze->getPixel(x*10+5-k, y*10+5);
        pixel.h = 0; pixel.s = 1; pixel.l = 0.5; pixel.a = 1;
      }
      x--;
    }
    // up
    else{
      for (int k = 0; k <= 10; k++){
        HSLAPixel& pixel = maze->getPixel(x*10+5, y*10+5-k);
        pixel.h = 0; pixel.s = 1; pixel.l = 0.5; pixel.a = 1;
      }
      y--;
    }
  }
  for (int k = 1; k < 10; k++){
    HSLAPixel& pixel = maze->getPixel(x*10+k, (y+1)*10);
    pixel.h = 0; pixel.s = 0; pixel.l = 1; pixel.a = 1;
  }
  return maze;
}
