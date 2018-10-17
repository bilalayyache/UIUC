/**
 * CS 225 lab_avl
 * @file main.cpp
 * @author Daniel Hoodin in Spring 2008.
 * Modified by Kyle Johnson in Fall 2010.
 * Modified by Sean Massung in Summer 2012:
 *  - added templates
 *  - CRTP tree printing
 *  - doxygen
 */

#include <iostream>
#include <sstream>
#include <string>
#include "avltree.h"
#include "coloredout.h"

using namespace std;

void printHeader(const string& headline)
{
    cout << string(64, colored_out::BORDER_CHAR) << endl;
    colored_out::output_bold(headline);
    cout << endl << string(64, colored_out::BORDER_CHAR) << endl;
}

void printBefore()
{
    cout << "~";
    colored_out::output_bold("Before");
    cout << "~" << endl;
}

void printAfter(int inserted)
{
    cout << endl << "~";
    colored_out::output_bold("After insert(");
    colored_out::output_bold(inserted);
    colored_out::output_bold(")");
    cout << "~" << endl;
}

void printEnd()
{
    cout << endl << endl;
}

using namespace std;

int main(){
  AVLTree<int, int> tree;
  tree.insert(4, 4);
  tree.insert(6, 6);
  tree.insert(2, 2);
  tree.insert(7, 7);
  tree.insert(5, 5);
  printBefore();
  tree.print();
  printAfter(9);
  tree.insert(9, 9);
  tree.print();
  printEnd();
  tree.printHeight();
}
