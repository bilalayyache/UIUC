/**
 * @file maptiles.cpp
 * Code for the maptiles function.
 */

#include <iostream>
#include <map>
#include "maptiles.h"

using namespace std;

Point<3> convertToLAB(HSLAPixel pixel) {
    Point<3> result(pixel.h/360, pixel.s, pixel.l);
    return result;
}

MosaicCanvas* mapTiles(SourceImage const& theSource,
                       vector<TileImage>& theTiles)
{
    /**
     * @todo Implement this function!
     */
    // first, we need to get the rows and columns of the picture
    int rows = theSource.getRows();
    int columns = theSource.getColumns();
    // then we need to set up a MosaicCanvas to hold the result
    MosaicCanvas* result = new MosaicCanvas(rows, columns);
    vector<Point<3>> pixel_vector;
    map<Point<3>, int> tile_avg_map;
    for (size_t i = 0; i < theTiles.size(); i++){
      HSLAPixel cur_pixel = theTiles[i].getAverageColor();
      Point<3> pixel = convertToLAB(cur_pixel);
      pixel_vector.push_back(pixel);
      tile_avg_map[pixel] = i;
    }
    KDTree<3> pixel_tree(pixel_vector);
    // fill in the map
    for (int i = 0; i < rows; i++){
      for (int j = 0; j < columns; j++){
        result->setTile(i, j, get_match_at_idx(pixel_tree, tile_avg_map, theTiles, theSource, i, j));
      }
    }
    return result;
}

TileImage* get_match_at_idx(const KDTree<3>& tree,
                                  map<Point<3>, int> tile_avg_map,
                                  vector<TileImage>& theTiles,
                                  const SourceImage& theSource, int row,
                                  int col)
{
    // Create a tile which accurately represents the source region we'll be
    // using
    HSLAPixel avg = theSource.getRegionColor(row, col);
    Point<3> avgPoint = convertToLAB(avg);
    Point<3> nearestPoint = tree.findNearestNeighbor(avgPoint);

    // Check to ensure the point exists in the map
    map< Point<3>, int >::iterator it = tile_avg_map.find(nearestPoint);
    if (it == tile_avg_map.end())
        cerr << "Didn't find " << avgPoint << " / " << nearestPoint << endl;

    // Find the index
    int index = tile_avg_map[nearestPoint];
    return &theTiles[index];

}
