#include <iterator>
#include <cmath>
#include <list>
#include <stack>

#include "../cs225/PNG.h"
#include "../Point.h"

#include "ImageTraversal.h"
#include "DFS.h"

using namespace cs225;

/**
 * Initializes a depth-first ImageTraversal on a given `png` image,
 * starting at `start`, and with a given `tolerance`.
 * @param png The image this DFS is going to traverse
 * @param start The start point of this DFS
 * @param tolerance If the current point is too different (difference larger than tolerance) with the start point,
 * it will not be included in this DFS
 */
DFS::DFS(const PNG & png, const Point & start, double tolerance)
  : png_(png), width_(png_.width()), height_(png_.height()), start_(start),
    startPixel_(png_.getPixel(start.x, start.y)){
  /** @todo [Part 1] */

  tolerance_ = tolerance;
  stack_.push(start_);
  isVisit_.assign(width_*height_, 0);
}

/**
 * Returns an iterator for the traversal starting at the first point.
 */
ImageTraversal::Iterator DFS::begin() {
  /** @todo [Part 1] */
  // isVisit_[start_.y*width_ + start_.x] = 1;
  return ImageTraversal::Iterator(this, start_);
}

/**
 * Returns an iterator for the traversal one past the end of the traversal.
 */
ImageTraversal::Iterator DFS::end() {
  /** @todo [Part 1] */
  return ImageTraversal::Iterator();
}

/**
 * Adds a Point for the traversal to visit at some point in the future.
 */
void DFS::add(const Point & point) {
  /** @todo [Part 1] */
  unsigned x_ = point.x; unsigned y_ = point.y;
  isVisit_[y_*width_+x_] = 1;
  if (x_+1 < width_ && isVisit_[y_*width_+x_+1] == 0){
    if (Delta(png_.getPixel(x_+1, y_), startPixel_) <= tolerance_){
      stack_.push(Point(x_+1, y_));
      //debug use
      /*
      if (x_ == 14 && y_ == 74){
        cout << "reach here 1" << endl;
        cout << "14, 74" << isVisit_[74*width_+14] << endl;
        cout << "14, 73" << isVisit_[73*width_+14] << endl;
        cout << "14, 75" << isVisit_[75*width_+14] << endl;
        cout << "13, 74" << isVisit_[74*width_+13] << endl;
        cout << "15, 74" << isVisit_[74*width_+15] << endl;
      }
      */
      // isVisit_[y_*width_+x_+1] = 1;
    }
  }
  if (y_+1 < height_ && isVisit_[(y_+1)*width_+x_] == 0){
    if (Delta(png_.getPixel(x_, y_+1), startPixel_) <= tolerance_){
      stack_.push(Point(x_, y_+1));
      // isVisit_[(y_+1)*width_+x_] = 1;
    }
  }
  if (x_ != 0 && isVisit_[y_*width_+x_-1] == 0){
    if (Delta(png_.getPixel(x_-1, y_), startPixel_) <= tolerance_){
      stack_.push(Point(x_-1, y_));
      // isVisit_[y_*width_+x_-1] = 1;
    }
  }
  if (y_ != 0 && isVisit_[(y_-1)*width_+x_] == 0){
    if (Delta(png_.getPixel(x_, y_-1), startPixel_) <= tolerance_){
      stack_.push(Point(x_, y_-1));
      // isVisit_[(y_-1)*width_+x_] = 1;
    }
  }
}

/**
 * Removes and returns the current Point in the traversal.
 */
Point DFS::pop() {
  /** @todo [Part 1] */
  Point point = stack_.top();
  stack_.pop();
  if (stack_.empty())
    return point;
  isVisit_[point.y*width_+point.x] = 1;
  Point temp = stack_.top();
  while (isVisit_[temp.y*width_+temp.x] == 1 && !stack_.empty()){
    stack_.pop();
    if (stack_.empty())
      break;
    temp = stack_.top();
  }
  return point;
}

/**
 * Returns the current Point in the traversal.
 */
Point DFS::peek() const {
  /** @todo [Part 1] */
  return stack_.top();
}

/**
 * Returns true if the traversal is empty.
 */
bool DFS::empty() const {
  /** @todo [Part 1] */
  return stack_.empty();
}

void DFS::setvector(const Point& point){
  isVisit_[point.y*width_+point.x] = 1;
}
