/*
 * Introductory paragraph
 * In this file, it contains three functions for the game of live.
 * First function is called countLiveNeighbor, which determines whether the current
   cell will be alive or not in next generation.
 * Second function is called updateBoard, which update the game board by using the
   first function to make necessary changes to the board.
 * Third function is called aliveStable, which check whether the board is stable or not.
   If the board is stable, it does not need to make any further changes to the board.
 */



/*
 * countLiveNeighbor
 * Inputs:
 * board: 1-D array of the current game board. 1 represents a live cell.
 * 0 represents a dead cell
 * boardRowSize: the number of rows on the game board.
 * boardColSize: the number of cols on the game board.
 * row: the row of the cell that needs to count alive neighbors.
 * col: the col of the cell that needs to count alive neighbors.
 * Output:
 * return the number of alive neighbors. There are at most eight neighbors.
 * Pay attention for the edge and corner cells, they have less neighbors.
 */

int countLiveNeighbor(int* board, int boardRowSize, int boardColSize, int row, int col){
		/* in this function, what we need to pay attention is when we are checking cells that
		   at the corners or edges of the board, number of its neighbors is not 8 and we need
			 to check their neighbors carefully.
		 */
		int H = boardRowSize;														// simplify the variable name
		int W = boardColSize;
		int i, j;																				//iteration variables, for rows and columns
		int count = 0;																	// count for alive cells around this cell
		for (i = row - 1; i <= row + 1; i++){
				if (i < 0 || i >= H)												// check left and right boundaries
						continue;
				for (j = col - 1; j <= col + 1; j++){				// check up and down boundaries
						if (j < 0 || j >= W)
								continue;
						count += board[i * W + j];							// add all the numbers that around this cell
				}
		}
		count -= board[row * W + col];									// finally subtract the number in this cell
		return count;
}
/*
 * Update the game board to the next step.
 * Input:
 * board: 1-D array of the current game board. 1 represents a live cell.
 * 0 represents a dead cell
 * boardRowSize: the number of rows on the game board.
 * boardColSize: the number of cols on the game board.
 * Output: board is updated with new values for next step.
 */
void updateBoard(int* board, int boardRowSize, int boardColSize){
		int H = boardRowSize;
		int W = boardColSize;
		int count[H * W];											// define a matrix that counts for alive neighbors
		int i, j;															// row and column pointer
		for (i = 0; i < H; i++){							// calculate the matrix count
				for (j = 0; j < W; j++){
						count[i * W + j] = countLiveNeighbor(board, H, W, i, j);
				}
		}
		for (i = 0; i < H; i++){							// begin updating the board
				for (j = 0; j < W; j++){					// there are two situations that the board needs to be updated
						if (count[i*W+j] == 3 && board[i*W+j] == 0)
								board[i*W+j] = 1;
						else if ((count[i*W+j] < 2 || count[i*W+j] > 3) && board[i*W+j] == 1)
								board[i*W+j] = 0;
				}
		}
}

/*
 * aliveStable
 * Checks if the alive cells stay the same for next step
 * board: 1-D array of the current game board. 1 represents a live cell.
 * 0 represents a dead cell
 * boardRowSize: the number of rows on the game board.
 * boardColSize: the number of cols on the game board.
 * Output: return 1 if the alive cells for next step is exactly the same with
 * current step or there is no alive cells at all.
 * return 0 if the alive cells change for the next step.
 */
int aliveStable(int* board, int boardRowSize, int boardColSize){
		int i, j;																				// iteration variables
		int count;																			// count the # of alive neighbors
		int H = boardRowSize;
		int W = boardColSize;
		int flag = 1;																		// set flag to indicate whether the board is changed
		for (i = 0; i < H; i++){
				for (j = 0; j < W; j++){
					count = countLiveNeighbor(board, H, W, i, j);
					if (count == 3 && board[i*W+j] == 0)			// if a cell is changed, I times a 0 to flag to make it 0
							flag *= 0;
					else if ((count < 2 || count > 3) && board[i*W+j] == 1)
							flag *= 0;
				}
		}
		return flag;
}
