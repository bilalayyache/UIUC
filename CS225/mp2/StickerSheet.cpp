#include <iostream>
#include <string>
#include "StickerSheet.h"

using namespace std;

StickerSheet::StickerSheet(const Image& other, unsigned max){
  max_ = max;
  base_ = other;
  sticker_array = new Image*[max_];
  x_array = new unsigned[max_];
  y_array = new unsigned[max_];
  for (unsigned i = 0; i < max_; i++){
    sticker_array[i] = NULL;
    x_array[i] = 0;
    y_array[i] = 0;
  }
}

void StickerSheet::clear(){
  if (sticker_array == NULL)
    return;
  else{
    for (unsigned i = 0; i < max_; i++){
      delete sticker_array[i];
    }
    delete[] sticker_array;
    sticker_array = NULL;
    delete[] x_array;
    x_array = NULL;
    delete[] y_array;
    y_array = NULL;
  }
}

StickerSheet::~StickerSheet(){
  this->clear();
}

void StickerSheet::copy(const StickerSheet& other){
  max_ = other.max_;
  base_ = other.base_;
  sticker_array = new Image*[max_];
  x_array = new unsigned[max_];
  y_array = new unsigned[max_];
  for (unsigned i = 0; i < max_; i++){
    if (other.sticker_array[i] != NULL){
      sticker_array[i] = new Image(*(other.sticker_array[i]));
    }
    else{
      sticker_array[i] = NULL;
    }
    x_array[i] = other.x_array[i];
    y_array[i] = other.y_array[i];
  }
}

StickerSheet::StickerSheet(const StickerSheet& other){
  this->copy(other);
}

const StickerSheet& StickerSheet::operator=(const StickerSheet& other){
  if (this != &other){
    this->clear();
    this->copy(other);
  }
  return *this;
}


void StickerSheet::changeMaxStickers(unsigned max){
  if (max_ == max)
    return;
  unsigned length = (max_ < max ? max_ : max);
  // initialize three new arrays
  Image** new_sticker_array = new Image*[max];
  for (unsigned i = 0; i < max; i++){
    new_sticker_array[i] = NULL;
  }
  unsigned* new_x_array = new unsigned[max];
  unsigned* new_y_array = new unsigned[max];
  // make deep copies of arrays
  for (unsigned i = 0; i < length; i++){
    if (sticker_array[i] != NULL){
      new_sticker_array[i] = new Image(*(sticker_array[i]));
    }
    new_x_array[i] = x_array[i];
    new_y_array[i] = y_array[i];
  }

  // clear old arrays
  for (unsigned i = 0; i < max_; i++){
    if (sticker_array != NULL){
      delete sticker_array[i];
    }
  }
  delete[] sticker_array;
  delete[] x_array;
  delete[] y_array;
  // update to new arrays
  x_array = new_x_array;
  y_array = new_y_array;
  sticker_array = new_sticker_array;
  // update max_
  max_ = max;
}

int StickerSheet::addSticker(Image& sticker, unsigned x, unsigned y){
  for (unsigned i = 0; i < max_; i++){
    if (sticker_array[i] == NULL){
      sticker_array[i] = new Image(sticker);
      x_array[i] = x;
      y_array[i] = y;
      return i;
    }
  }
  return -1;
}




bool StickerSheet::translate(unsigned index, unsigned x, unsigned y){
  if ((sticker_array[index] == NULL) || (index >= max_))
    return false;
  else{
    x_array[index] = x;
    y_array[index] = y;
    return true;
  }
}

void StickerSheet::removeSticker(unsigned index){
  if ((sticker_array[index] == NULL) || (index >= max_))
    return;
  else{
    x_array[index] = 0;
    y_array[index] = 0;
    delete sticker_array[index];
    sticker_array[index] = NULL;
  }
}


Image* StickerSheet::getSticker(unsigned index)const{
  if ((sticker_array[index] == NULL) || (index >= max_))
    return NULL;
  else{
    return sticker_array[index];
  }
}


Image StickerSheet::render()const{
  Image output = base_;
  // first find the final size of the output
  unsigned x_max = output.width();
  unsigned y_max = output.height();
  for (unsigned i = 0; i < max_; i++){
    if (sticker_array[i] != NULL){
      if (x_max < x_array[i]+sticker_array[i]->width()){
        x_max = x_array[i]+sticker_array[i]->width();
      }
      if (y_max < y_array[i]+sticker_array[i]->height()){
        y_max = y_array[i]+sticker_array[i]->height();
      }
    }
  }
  output.resize(x_max, y_max);

  // now add stickers to the output
  for (unsigned i = 0; i < max_; i++){
    if (sticker_array[i] != NULL){
      unsigned sticker_width = sticker_array[i]->width();
      unsigned sticker_height = sticker_array[i]->height();
      for (unsigned x = x_array[i]; x < x_array[i]+sticker_width; x++){
        for (unsigned y = y_array[i]; y < y_array[i]+sticker_height; y++){
          HSLAPixel& oldpixel = output.getPixel(x, y);
          HSLAPixel& newpixel = sticker_array[i]->getPixel(x-x_array[i], y-y_array[i]);
          if (newpixel.a != 0){
            oldpixel = newpixel;
          }
        }
      }
    }
  }
  return output;
}
