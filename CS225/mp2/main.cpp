#include "Image.h"
#include "StickerSheet.h"

int main() {

  //
  // Reminder:
  //   Before exiting main, save your creation to disk as myImage.png
  //
  // base picture
  Image inspire;
  inspire.readFromFile("inspire.png");
  unsigned width = inspire.width();
  unsigned height = inspire.height();
  StickerSheet sheet(inspire, 5);
  cout << "width of base picture is " << width << endl;
  cout << "height of base picture is " << height << endl;

  // stickers
  Image boy;
  boy.readFromFile("boy.png");
  Image rng;
  rng.readFromFile("we_rng.png");
  Image cpp;
  cpp.readFromFile("cpp.png");
  sheet.addSticker(boy, 100, 460);
  sheet.addSticker(cpp, 980, 150);
  sheet.addSticker(rng, 350, 1300);
  Image output = sheet.render();
  output.writeToFile("myImage.png");

  return 0;
}
