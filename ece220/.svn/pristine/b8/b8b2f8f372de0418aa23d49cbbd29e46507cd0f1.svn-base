#include "game.h"

/*
  Introduction
  In this file, it containes many functions that implement 2048 game.
  First, we need to make the board for our game, so we have make_game function. It gets the rows and cols
  from user and return a pointer that points to the struct mygame, which contains the information for the game.

  Second, we need to remake the game if user wants to start a new game, so we have remake_game function, which clear
  the current game board and create a new one.

  Third, we need a function to return the location (pointer) of a given cell in our game board. This can help us
  generate a random number at this location for our game.

  At last, we need to move and merge the numbers on our board. We have 4 choices which are 'w', 'a', 's', and 'd',
  stading for up, down, left and right. In this four functions, we need to first move all numbers to the direction
  given by user and merge the same number together. While merging two same tiles, the resulting tile cannot merge
  with another tile again in the same move.

*/
game * make_game(int rows, int cols)
/*! Create an instance of a game structure with the given number of rows
    and columns, initializing elements to -1 and return a pointer
    to it. (See game.h for the specification for the game data structure)
    The needed memory should be dynamically allocated with the malloc family
    of functions.
*/
{
  //Dynamically allocate memory for game and cells (DO NOT modify this)
  game * mygame = malloc(sizeof(game));
  mygame->cells = malloc(rows*cols*sizeof(cell));

  //YOUR CODE STARTS HERE:  Initialize all other variables in game struct
  mygame->rows = rows;                          // initialize rows and cols in struct game
  mygame->cols = cols;
  int i, j;                                     // row and column counter
  for (i = 0; i < rows; i++){
    for (j = 0; j < cols; j++){
      mygame->cells[i * cols + j] = -1;     // initialize every item in cells to be -1
    }
  }
  mygame->score = 0;                            // initializing scores
  return mygame;
}

void remake_game(game ** _cur_game_ptr,int new_rows,int new_cols)
/*! Given a game structure that is passed by reference, change the
	game structure to have the given number of rows and columns. Initialize
	the score and all elements in the cells to -1. Make sure that any
	memory previously allocated is not lost in this function.
*/
{
	/*Frees dynamically allocated memory used by cells in previous game,
	 then dynamically allocates memory for cells in new game.  DO NOT MODIFY.*/
  free((*_cur_game_ptr)->cells);
	(*_cur_game_ptr)->cells = malloc(new_rows*new_cols*sizeof(cell));

	//YOUR CODE STARTS HERE:  Re-initialize all other variables in game struct
  (*_cur_game_ptr)->rows = new_rows;         // initialize new_rows and new_cols
  (*_cur_game_ptr)->cols = new_cols;
  int i, j;                                  // row and column counter
  for (i = 0; i < new_rows; i++){
    for (j = 0; j < new_cols; j++){
      (*_cur_game_ptr)->cells[i * new_cols + j] = -1;
    }
  }
  (*_cur_game_ptr)->score = 0;
  return;
}

void destroy_game(game * cur_game)
/*! Deallocate any memory acquired with malloc associated with the given game instance.
    This includes any substructures the game data structure contains. Do not modify this function.*/
{
  free(cur_game->cells);
  free(cur_game);
  cur_game = NULL;
  return;
}

cell * get_cell(game * cur_game, int row, int col)
/*! Given a game, a row, and a column, return a pointer to the corresponding
    cell on the game. (See game.h for game data structure specification)
    This function should be handy for accessing game cells. Return NULL
	if the row and col coordinates do not exist.
*/
{
  //YOUR CODE STARTS HERE
  int board_row, board_col;             // define variables to hold the rows and columns of the game board
  board_row = cur_game->rows;           // find the rows and columns of the game board
  board_col = cur_game->cols;
  if (row >= 0 && row <= board_row && col >= 0 && col <= board_col){    // check whether row and col are in the valid range
    cell * target_cell = &(cur_game->cells[row * board_col + col]);
    return target_cell;
  }
  return NULL;
}

// slide_up function comes from lab8 except the return value
// return value of slide_up indicates whether there is a move made in this process
// output: 1 if there are any move made and 0 if nothing changed
int slide_up(int* my_array, int rows, int cols)
{
  int i, j;                   // row and column indices
  int k;                      // when encounter a -1, move all values below
  int flag = 0;               // return value of the function
  for (j = 0; j < cols; j++){
    for (i = 0; i < rows - 1; i++){           // for slide_up, we only need to check until (row-1)
      if (my_array[i * cols + j] == -1){      // if encounter a -1, do swap
        for (k = i + 1; k < rows; k++){       // to do swap, need to find a number that is not -1
          if (my_array[k * cols + j] != -1){
            my_array[i * cols + j] = my_array[k * cols + j]; // do the swap
            my_array[k * cols + j] = -1;
            flag = 1;
            break;                            // everytime you only do one swap. so break here
          }
        }
      }
    }
  }
  return flag;
}



int slide_down(int* my_array, int rows, int cols)
{
  int i, j;                   // row and column indices
  int k;                      // when encounter a -1, move all values below
  int flag = 0;               // return value of the function
  for (j = 0; j < cols; j++){
    for (i = rows - 1; i > 0; i--){           // for slide_down, we only need to check until first row
      if (my_array[i * cols + j] == -1){      // if encounter a -1, do swap
        for (k = i - 1; k >= 0; k--){         // to do swap, need to find a number that is not -1
          if (my_array[k * cols + j] != -1){
            my_array[i * cols + j] = my_array[k * cols + j]; // do the swap
            my_array[k * cols + j] = -1;
            flag = 1;
            break;                            // everytime you only do one swap. so break here
          }
        }
      }
    }
  }
  return flag;
}


int slide_left(int* my_array, int rows, int cols)
{
  int i, j;                   // row and column indices
  int k;                      // when encounter a -1, move all values below
  int flag = 0;               // return value of the function
  for (i = 0; i < rows; i++){
    for (j = 0; j < cols-1; j++){
      if (my_array[i * cols + j] == -1){      // if encounter a -1, do swap
        for (k = j + 1; k < cols; k++){       // to do swap, need to find a number that is not -1
          if (my_array[i * cols + k] != -1){
            my_array[i * cols + j] = my_array[i * cols + k]; // do the swap
            my_array[i * cols + k] = -1;
            flag = 1;
            break;                            // everytime you only do one swap. so break here
          }
        }
      }
    }
  }
  return flag;
}


int slide_right(int* my_array, int rows, int cols)
{
  int i, j;                   // row and column indices
  int k;                      // when encounter a -1, move all values below
  int flag = 0;               // return value of the function
  for (i = 0; i < rows; i++){
    for (j = cols-1; j > 0; j--){
      if (my_array[i * cols + j] == -1){    // if encounter a -1, do swap
        for (k = j - 1; k >= 0; k--){       // to do swap, need to find a number that is not -1
          if (my_array[i * cols + k] != -1){
            my_array[i * cols + j] = my_array[i * cols + k]; // do the swap
            my_array[i * cols + k] = -1;
            flag = 1;
            break;                          // everytime you only do one swap. so break here
          }
        }
      }
    }
  }
  return flag;
}


int move_w(game * cur_game)
/*!Slides all of the tiles in cur_game upwards. If a tile matches with the
   one above it, the tiles are merged by adding their values together. When
   tiles merge, increase the score by the value of the new tile. A tile can
   not merge twice in one turn. If sliding the tiles up does not cause any
   cell to change value, w is an invalid move and return 0. Otherwise, return 1.
*/

/*
Algorithm:
    The following four functions are doing the same thing: move the numbers and merge the same ones.
    The whole process can be break down to three steps:
    1. move all positive values to one side
    2. check whether there are cells that can be mergedddd together
    3. after merging, move the board again to find the final output of the process
*/
{
  //YOUR CODE STARTS HERE
  // First do initializations
  cell * board = cur_game->cells;
  int rows = cur_game->rows;
  int cols = cur_game->cols;
  int flag = 0;                               // indicates whether the move is valid
  flag = slide_up(board, rows, cols);         // use slide_up function to finish step 1
  int i, j;                                   // row and column counters
  for (i = 0; i < rows - 1; i++){             // to check merge, only need to go to (row-1)
    for (j = 0; j < cols; j++){
      if (board[i * cols + j] == -1)
        continue;
      if (board[i * cols + j] == board[(i + 1) * cols + j]){
        board[i * cols + j] = 2 * board[i * cols + j];
        cur_game->score += board[i * cols + j];
        board[(i + 1) * cols + j] = -1;
        flag += 1;
      }
    }
  }
  flag += slide_up(board, rows, cols);        // to check step 3
  if (flag == 0)
    return 0;
  else
    return 1;
}


int move_s(game * cur_game) //slide down
{
  //YOUR CODE STARTS HERE
  // First do initializations
  cell * board = cur_game->cells;
  int rows = cur_game->rows;
  int cols = cur_game->cols;
  int flag = 0;                               // indicates whether the move is valid
  flag = slide_down(board, rows, cols);       // use slide_up function to finish step 1
  int i, j;                                   // row and column counters
  for (i = rows-1; i > 0; i--){
    for (j = 0; j < cols; j++){
      if (board[i * cols + j] == -1)
        continue;
      if (board[i * cols + j] == board[(i - 1) * cols + j]){
        board[i * cols + j] = 2 * board[i * cols + j];
        cur_game->score += board[i * cols + j];
        board[(i - 1) * cols + j] = -1;
        flag += 1;
      }
    }
  }
  flag += slide_down(board, rows, cols);
  if (flag == 0)
    return 0;
  else
    return 1;
}

int move_a(game * cur_game) //slide left
{
  //YOUR CODE STARTS HERE
  // First do initializations
  cell * board = cur_game->cells;
  int rows = cur_game->rows;
  int cols = cur_game->cols;
  int flag = 0;                               // indicates whether the move is valid
  flag = slide_left(board, rows, cols);       // use slide_up function to finish step 1
  int i, j;                                   // row and column counters
  for (j = 0; j < cols - 1; j++){             // to check merge, only need to go to (cols-1)
    for (i = 0; i < rows; i++){
      if (board[i * cols + j] == -1)
        continue;
      if (board[i * cols + j] == board[i * cols + j + 1]){
        board[i * cols + j] = 2 * board[i * cols + j];
        cur_game->score += board[i * cols + j];
        board[i * cols + j + 1] = -1;
        flag += 1;
      }
    }
  }
  flag += slide_left(board, rows, cols);
  if (flag == 0)
    return 0;
  else
    return 1;
};

int move_d(game * cur_game){ //slide to the right
  //YOUR CODE STARTS HERE
  // First do initializations
  cell * board = cur_game->cells;
  int rows = cur_game->rows;
  int cols = cur_game->cols;
  int flag = 0;                               // indicates whether the move is valid
  flag = slide_right(board, rows, cols);         // use slide_up function to finish step 1
  int i, j;                                   // row and column counters
  for (j = cols-1; j > 0; j--){
    for (i = 0; i < rows; i++){
      if (board[i * cols + j] == -1)
        continue;
      if (board[i * cols + j] == board[i* cols + j - 1]){
        board[i * cols + j] = 2 * board[i * cols + j];
        cur_game->score += board[i * cols + j];
        board[i* cols + j - 1] = -1;
        flag += 1;
      }
    }
  }
  flag += slide_right(board, rows, cols);
  if (flag == 0)
    return 0;
  else
    return 1;
};





int legal_move_check(game * cur_game)
/*! Given the current game check if there are any legal moves on the board. There are
    no legal moves if sliding in any direction will not cause the game to change.
	Return 1 if there are possible legal moves, 0 if there are none.
 */

/*
Algorithm:
    Check if all cells are full and for each cell, its four neighbors contain different value
*/
{
  //YOUR CODE STARTS HERE
  int i, j;                           // row and column counter
  int rows, cols;                     // size of the game board
  rows = cur_game->rows;
  cols = cur_game->cols;
  cell *board = cur_game->cells;       // create board as the game board
  for (i = 0; i < rows; i++){
    for (j = 0; j < cols; j++){
      if (board[i * cols + j] == -1)    // if some value of board is -1, board is not full
        return 1;
      else{                             // if every cell on board is full, check its neighbor's value
        if (i > 0 && board[i * cols + j] == board[(i - 1) * cols + j])
          return 1;
        if (i < rows - 1 && board[i * cols + j] == board[(i + 1) * cols + j])
          return 1;
        if (j > 0 && board[i * cols + j] == board[i * cols + j - 1])
          return 1;
        if (j < cols - 1 && board[i * cols + j] == board[i * cols + j + 1])
          return 1;
      }
    }
  }
  return 0;
}


/*! code below is provided and should not be changed */

void rand_new_tile(game * cur_game)
/*! insert a new tile into a random empty cell. First call rand()%(rows*cols) to get a random value between 0 and (rows*cols)-1.
*/
{

	cell * cell_ptr;
  cell_ptr = 	cur_game->cells;

  if (cell_ptr == NULL){
    printf("Bad Cell Pointer.\n");
    exit(0);
  }


	//check for an empty cell
	int emptycheck = 0;
	int i;

	for(i = 0; i < ((cur_game->rows)*(cur_game->cols)); i++){
		if ((*cell_ptr) == -1){
				emptycheck = 1;
				break;
		}
        cell_ptr += 1;
	}
	if (emptycheck == 0){
		printf("Error: Trying to insert into no a board with no empty cell. The function rand_new_tile() should only be called after tiles have succesfully moved, meaning there should be at least 1 open spot.\n");
		exit(0);
	}

    int ind,row,col;
	int num;
    do{
		ind = rand()%((cur_game->rows)*(cur_game->cols));
		col = ind%(cur_game->cols);
		row = ind/cur_game->cols;
    } while ( *get_cell(cur_game, row, col) != -1);
        //*get_cell(cur_game, row, col) = 2;
	num = rand()%20;
	if(num <= 1){
		*get_cell(cur_game, row, col) = 4; // 1/10th chance
	}
	else{
		*get_cell(cur_game, row, col) = 2;// 9/10th chance
	}
}

int print_game(game * cur_game)
{
    cell * cell_ptr;
    cell_ptr = 	cur_game->cells;

    int rows = cur_game->rows;
    int cols = cur_game->cols;
    int i,j;

	printf("\n\n\nscore:%d\n",cur_game->score);


	printf("\u2554"); // topleft box char
	for(i = 0; i < cols*5;i++)
		printf("\u2550"); // top box char
	printf("\u2557\n"); //top right char


    for(i = 0; i < rows; i++){
		printf("\u2551"); // side box char
        for(j = 0; j < cols; j++){
            if ((*cell_ptr) == -1 ) { //print asterisks
                printf(" **  ");
            }
            else {
                switch( *cell_ptr ){ //print colored text
                    case 2:
                        printf("\x1b[1;31m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 4:
                        printf("\x1b[1;32m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 8:
                        printf("\x1b[1;33m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 16:
                        printf("\x1b[1;34m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 32:
                        printf("\x1b[1;35m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 64:
                        printf("\x1b[1;36m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 128:
                        printf("\x1b[31m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 256:
                        printf("\x1b[32m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 512:
                        printf("\x1b[33m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 1024:
                        printf("\x1b[34m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 2048:
                        printf("\x1b[35m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 4096:
                        printf("\x1b[36m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 8192:
                        printf("\x1b[31m%04d\x1b[0m ",(*cell_ptr));
                        break;
					default:
						printf("  X  ");

                }

            }
            cell_ptr++;
        }
	printf("\u2551\n"); //print right wall and newline
    }

	printf("\u255A"); // print bottom left char
	for(i = 0; i < cols*5;i++)
		printf("\u2550"); // bottom char
	printf("\u255D\n"); //bottom right char

    return 0;
}

int process_turn(const char input_char, game* cur_game) //returns 1 if legal move is possible after input is processed
{
	int rows,cols;
	char buf[200];
	char garbage[2];
    int move_success = 0;

    switch ( input_char ) {
    case 'w':
        move_success = move_w(cur_game);
        break;
    case 'a':
        move_success = move_a(cur_game);
        break;
    case 's':
        move_success = move_s(cur_game);
        break;
    case 'd':
        move_success = move_d(cur_game);
        break;
    case 'q':
        destroy_game(cur_game);
        printf("\nQuitting..\n");
        return 0;
        break;
	case 'n':
		//get row and col input for new game
		dim_prompt: printf("NEW GAME: Enter dimensions (rows columns):");
		while (NULL == fgets(buf,200,stdin)) {
			printf("\nProgram Terminated.\n");
			return 0;
		}

		if (2 != sscanf(buf,"%d%d%1s",&rows,&cols,garbage) ||
		rows < 0 || cols < 0){
			printf("Invalid dimensions.\n");
			goto dim_prompt;
		}

		remake_game(&cur_game,rows,cols);

		move_success = 1;

    default: //any other input
        printf("Invalid Input. Valid inputs are: w, a, s, d, q, n.\n");
    }




    if(move_success == 1){ //if movement happened, insert new tile and print the game.
         rand_new_tile(cur_game);
		 print_game(cur_game);
    }

    if( legal_move_check(cur_game) == 0){  //check if the newly spawned tile results in game over.
        printf("Game Over!\n");
        return 0;
    }
    return 1;
}
