/**
 * @file StickerSheet.h
 * Contains your declaration of the interface for the StickerSheet class.
 */
#ifndef STICKERSHEET_H_
#define STICKERSHEET_H_
#include "Image.h"

class StickerSheet{
  public:
    // constructor, destructor, copy constructor, assignment
    StickerSheet(const Image& picture, unsigned max);
    ~StickerSheet();
    StickerSheet(const StickerSheet& other);
    const StickerSheet& operator=(const StickerSheet& other);

    // member functions
    void changeMaxStickers(unsigned max);
    int addSticker(Image& sticker, unsigned x, unsigned y);
    bool translate(unsigned index, unsigned x, unsigned y);
    void removeSticker(unsigned index);
    Image* getSticker(unsigned index)const;
    Image render()const;

  private:
    void copy(const StickerSheet& other);
    void clear();
    // base picture
    Image base_;
    // array to store stickers
    Image ** sticker_array;
    // arrays to store x, y coordinates
    unsigned *x_array, *y_array;
    // max number of stickers in this stickersheet
    unsigned max_;

};



#endif
