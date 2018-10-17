#include "cs225/PNG.h"
#include "cs225/HSLAPixel.h"
#include <string>

using namespace cs225;


void rotate(std::string inputFile, std::string outputFile) {
  // Part 2
  PNG png1;
  png1.readFromFile(inputFile);
  unsigned int width = png1.width();
  unsigned int height = png1.height();
  PNG png2(width, height);
  for (unsigned int x = 0; x < width; x++){
    for (unsigned int y = 0; y < height; y++){
      HSLAPixel * pixel1 = png1.getPixel(x, y);
      HSLAPixel * pixel2 = png2.getPixel(width - x - 1, height - y - 1);
      pixel2->h = pixel1->h;
      pixel2->s = pixel1->s;
      pixel2->l = pixel1->l;
      pixel2->a = pixel1->a;
    }
  }
  png2.writeToFile(outputFile);
}


PNG myArt(unsigned int width, unsigned int height) {
  PNG png(width, height);
  // Part 3
  for (unsigned int x = 0; x < width; x++){
    for (unsigned int y = 0; y < height; y++){
      HSLAPixel * pixel = png.getPixel(x, y);
      pixel->h = 360 * (x + y) / (width + height);
      pixel->s = 0.5;
      pixel->l = 0.5;
      pixel->a = 1;
    }
  }
  return png;
}
