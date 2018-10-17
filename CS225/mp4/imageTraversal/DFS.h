/**
 * @file DFS.h
 */

#ifndef DFS_H
#define DFS_H

#include <iterator>
#include <cmath>
#include <list>
#include <stack>
#include <vector>

#include "../cs225/PNG.h"
#include "../Point.h"

#include "ImageTraversal.h"

using namespace cs225;

/**
 * A depth-first ImageTraversal.
 * Derived from base class ImageTraversal
 */
class DFS : public ImageTraversal {
public:
  DFS(const PNG & png, const Point & start, double tolerance);

  ImageTraversal::Iterator begin();
  ImageTraversal::Iterator end();

  void add(const Point & point);
  Point pop();
  Point peek() const;
  bool empty() const;
  void setvector(const Point& point);

private:
	/** @todo [Part 1] */
	/** add private members here*/
  PNG png_;
  // store the width and height of the png
  // in order to keep track of the visited point
  const unsigned width_;
  const unsigned height_;
  stack<Point> stack_;
  const Point start_;
  double tolerance_;
  vector<int> isVisit_;
  HSLAPixel& startPixel_;
};

#endif
