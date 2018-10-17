#include <iterator>
#include <cmath>
#include <list>
#include <queue>

#include "../cs225/PNG.h"
#include "../Point.h"

#include "ImageTraversal.h"
#include "BFS.h"

using namespace cs225;

/**
 * Initializes a breadth-first ImageTraversal on a given `png` image,
 * starting at `start`, and with a given `tolerance`.
 * @param png The image this BFS is going to traverse
 * @param start The start point of this BFS
 * @param tolerance If the current point is too different (difference larger than tolerance) with the start point,
 * it will not be included in this BFS
 */
BFS::BFS(const PNG & png, const Point & start, double tolerance)
  : png_(png), width_(png_.width()), height_(png_.height()), start_(start),
    startPixel_(png_.getPixel(start.x, start.y)){
   /** @todo [Part 1] */

   tolerance_ = tolerance;
   queue_.push(start_);
   isVisit_.assign(width_*height_, 0);
 }

/**
 * Returns an iterator for the traversal starting at the first point.
 */
ImageTraversal::Iterator BFS::begin() {
  /** @todo [Part 1] */
  isVisit_[start_.y*width_ + start_.x] = 1;
  return ImageTraversal::Iterator(this, start_);
}

/**
 * Returns an iterator for the traversal one past the end of the traversal.
 */
ImageTraversal::Iterator BFS::end() {
  /** @todo [Part 1] */
  return ImageTraversal::Iterator();
}

/**
 * Adds a Point for the traversal to visit at some point in the future.
 */
void BFS::add(const Point & point) {
  /** @todo [Part 1] */
  unsigned x_ = point.x; unsigned y_ = point.y;
  if (x_+1 < width_ && isVisit_[y_*width_+x_+1] == 0){
    if (Delta(png_.getPixel(x_+1, y_), startPixel_) <= tolerance_){
      queue_.push(Point(x_+1, y_));
      isVisit_[y_*width_+x_+1] = 1;
    }
  }
  if (y_+1 < height_ && isVisit_[(y_+1)*width_+x_] == 0){
    if (Delta(png_.getPixel(x_, y_+1), startPixel_) <= tolerance_){
      queue_.push(Point(x_, y_+1));
      isVisit_[(y_+1)*width_+x_] = 1;
    }
  }
  if (x_ != 0 && isVisit_[y_*width_+x_-1] == 0){
    if (Delta(png_.getPixel(x_-1, y_), startPixel_) <= tolerance_){
      queue_.push(Point(x_-1, y_));
      isVisit_[y_*width_+x_-1] = 1;
    }
  }
  if (y_ != 0 && isVisit_[(y_-1)*width_+x_] == 0){
    if (Delta(png_.getPixel(x_, y_-1), startPixel_) <= tolerance_){
      queue_.push(Point(x_, y_-1));
      isVisit_[(y_-1)*width_+x_] = 1;
    }
  }
}

/**
 * Removes and returns the current Point in the traversal.
 */
Point BFS::pop() {
  /** @todo [Part 1] */
  Point p = queue_.front();
  queue_.pop();
  return p;
}

/**
 * Returns the current Point in the traversal.
 */
Point BFS::peek() const {
  /** @todo [Part 1] */
  return queue_.front();
}

/**
 * Returns true if the traversal is empty.
 */
bool BFS::empty() const {
  /** @todo [Part 1] */
  return queue_.empty();
}

void BFS::setvector(const Point& point){
  // isVisit_[point.y*width_+point.x] = 1;
}
