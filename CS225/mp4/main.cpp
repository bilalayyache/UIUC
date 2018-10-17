
#include "cs225/PNG.h"
#include "FloodFilledImage.h"
#include "Animation.h"

#include "imageTraversal/DFS.h"
#include "imageTraversal/BFS.h"

#include "colorPicker/RainbowColorPicker.h"
#include "colorPicker/GradientColorPicker.h"
#include "colorPicker/GridColorPicker.h"
#include "colorPicker/SolidColorPicker.h"
#include "colorPicker/MyColorPicker.h"

using namespace cs225;

int main() {

  // @todo [Part 3]
  // - The code below assumes you have an Animation called `animation`
  // - The code provided below produces the `myFloodFill.png` file you must
  //   submit Part 3 of this assignment -- uncomment it when you're ready.

  /*
  PNG lastFrame = animation.getFrame( animation.frameCount() - 1 );
  lastFrame.writeToFile("myFloodFill.png");
  animation.write("myFloodFill.gif");
  */
  PNG png;      png.readFromFile("hw.png");
  FloodFilledImage image(png);
  BFS bfs(png, Point(309, 100), 0.2);
  DFS dfs(png, Point(0,   0  ), 0.2);
  HSLAPixel color(290, 1, 0.5);
  // face animation
  MyColorPicker solid(color);
  // background animation
  RainbowColorPicker rainbow(0.05);
  image.addFloodFill( bfs, solid );
  //image.addFloodFill( dfs, rainbow );
  // first animation
  Animation animation = image.animate(3000);
  PNG lastFrame = animation.getFrame( animation.frameCount() - 1 );
  lastFrame.writeToFile("myFloodFill_2.png");
  animation.write("myFloodFill_2.gif");

  return 0;
}
