#include <iostream>
#include <cmath>
#include "cs225/PNG.h"
#include "cs225/HSLAPixel.h"
#include "Image.h"

using namespace std;
using namespace cs225;

// constructor
Image::Image():PNG(){}
Image::Image(unsigned int width, unsigned int height):
            PNG(width, height){}

// public member functions
// lighten(), increase l 0.1 for every pixel but not exceed 1.0
void Image::lighten(){
  for (unsigned x = 0; x < this->width(); x++) {
    for (unsigned y = 0; y < this->height(); y++) {
      HSLAPixel & pixel = this->getPixel(x, y);
      pixel.l = fmin(pixel.l + 0.1, 1.0);
    }
  }
}

// lighten(double amount), increase l for input amount
void Image::lighten (double amount){
  for (unsigned x = 0; x < this->width(); x++) {
    for (unsigned y = 0; y < this->height(); y++) {
      HSLAPixel & pixel = this->getPixel(x, y);
      pixel.l = fmin(pixel.l + amount, 1.0);
    }
  }
}

// darken(), decrease l for 0.1
void Image::darken(){
  for (unsigned x = 0; x < this->width(); x++) {
    for (unsigned y = 0; y < this->height(); y++) {
      HSLAPixel & pixel = this->getPixel(x, y);
      pixel.l = fmax(pixel.l - 0.1, 0.0);
    }
  }
}

// darken(double amount), decrease l by amount
void Image::darken(double amount){
  for (unsigned x = 0; x < this->width(); x++) {
    for (unsigned y = 0; y < this->height(); y++) {
      HSLAPixel & pixel = this->getPixel(x, y);
      pixel.l = fmax(pixel.l - amount, 0.0);
    }
  }
}

// saturate(), increase s by 0.1
void Image::saturate(){
  for (unsigned x = 0; x < this->width(); x++) {
    for (unsigned y = 0; y < this->height(); y++) {
      HSLAPixel & pixel = this->getPixel(x, y);
      pixel.s = fmin(pixel.s + 0.1, 1.0);
    }
  }
}

// saturate(double amount), increase s by amount
void Image::saturate(double amount){
  for (unsigned x = 0; x < this->width(); x++) {
    for (unsigned y = 0; y < this->height(); y++) {
      HSLAPixel & pixel = this->getPixel(x, y);
      pixel.s = fmin(pixel.s + amount, 1.0);
    }
  }
}

// desaturate(), decrease s by 0.1
void Image::desaturate(){
  for (unsigned x = 0; x < this->width(); x++) {
    for (unsigned y = 0; y < this->height(); y++) {
      HSLAPixel & pixel = this->getPixel(x, y);
      pixel.s = fmax(pixel.s - 0.1, 0.0);
    }
  }
}

// desaturate(double amount), decrease s by amount
void Image::desaturate(double amount){
  for (unsigned x = 0; x < this->width(); x++) {
    for (unsigned y = 0; y < this->height(); y++) {
      HSLAPixel & pixel = this->getPixel(x, y);
      pixel.s = fmax(pixel.s - amount, 0.0);
    }
  }
}

// grayscale(), turn all pixel.s = 0 to be grayscale
void Image::grayscale(){
  for (unsigned x = 0; x < this->width(); x++) {
    for (unsigned y = 0; y < this->height(); y++) {
      HSLAPixel & pixel = this->getPixel(x, y);
      pixel.s = 0;
    }
  }
}

// rotateColor(double degrees), rotate hue on color circle
void Image::rotateColor(double degrees){
  for (unsigned x = 0; x < this->width(); x++) {
    for (unsigned y = 0; y < this->height(); y++) {
      HSLAPixel & pixel = this->getPixel(x, y);
      if (pixel.h + degrees > 360)
        pixel.h = pixel.h + degrees - 360;
      else if (pixel.h + degrees < 0)
        pixel.h = pixel.h + degrees + 360;
      else
        pixel.h = pixel.h + degrees;
    }
  }
}

// illinify()
void Image::illinify(){
  for (unsigned x = 0; x < this->width(); x++) {
    for (unsigned y = 0; y < this->height(); y++) {
      HSLAPixel & pixel = this->getPixel(x, y);
      // if h is in between from 113.5 to 293.5, then it is closer to 216 and therefore the hue is supposed to change to 216
      if (pixel.h <=293.5 && pixel.h >= 113.5)
        pixel.h = 216;
      else
        pixel.h = 11;
    }
  }
}

// scale(double factor)
void Image::scale(double factor){
  // find the new width and height
  int new_width = int(this->width() * factor);
  int new_height = int(this->height() * factor);
  this->scale(new_width, new_height);
}

// scale(unsigned w, unsigned h)
void Image::scale(unsigned w, unsigned h){
  double factor_w = w * 1.0 / this->width();
  double factor_h = h * 1.0 / this->height();
  Image *image = new Image(w, h);
  for (unsigned x = 0; x < w; x++) {
    for (unsigned y = 0; y < h; y++) {
      HSLAPixel & pixel = image->getPixel(x, y);
      // pixel in this new image maps to pixel in this image
      int this_x = int(x/factor_w);
      int this_y = int(y/factor_h);
      HSLAPixel & oldpixel = this->getPixel(this_x, this_y);
      pixel = oldpixel;
    }
  }
  // copy image to this
  *this = *image;
  delete image;
}
