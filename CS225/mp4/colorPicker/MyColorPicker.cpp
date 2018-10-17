#include "../cs225/HSLAPixel.h"
#include "../Point.h"

#include "ColorPicker.h"
#include "MyColorPicker.h"

using namespace cs225;

/**
 * Picks the color for pixel (x, y).
 * Using your own algorithm
 */

MyColorPicker::MyColorPicker(HSLAPixel color) : color(color){

}

HSLAPixel MyColorPicker::getColor(unsigned x, unsigned y) {
  /* @todo [Part 3] */
  // give the opposite color of a pixel
  double h = 360 - color.h;
  // change the s to 0.8 of the origin value
  double s = 0.8 * color.s;
  // keep l
  double l = color.l;
  return HSLAPixel(h, s, l);
}
