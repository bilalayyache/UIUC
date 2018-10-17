/**
 * @file anagram_dict.cpp
 * Implementation of the AnagramDict class.
 *
 * @author Matt Joras
 * @date Winter 2013
 */

#include "anagram_dict.h"

#include <algorithm> /* I wonder why this is included... */
#include <fstream>
#include <iostream>

using std::string;
using std::vector;
using std::ifstream;
using std::cout;
using std::endl;
/**
 * Constructs an AnagramDict from a filename with newline-separated
 * words.
 * @param filename The name of the word list file.
 */
AnagramDict::AnagramDict(const string& filename)
{
    /* Your code goes here! */
    // make a dictionary that the key is the string and the value are the characters that
    // contains in this string
    ifstream anagram_dict_file(filename);
    string str;
    if (anagram_dict_file.is_open()) {
      while (getline(anagram_dict_file, str)) {
        string strsort = stringsort(str);
        map<string, vector<string>>::const_iterator lookup = dict.find(strsort);
        if (lookup == dict.end()){
          vector<string> v_string;
          v_string.push_back(str);
          dict[strsort] = v_string;
        }
        else{
          dict[strsort].push_back(str);
        }
      }
    }

    // for (size_t i = 0; i < words.size(); i++){
    //   vector<string> s;
    //   for (size_t j = 0; j < words.size(); j++){
    //     if (i == j)
    //       continue;
    //     if (is_anagram(words[i], words[j])){
    //       s.push_back(words[j]);
    //     }
    //   }
    //   if (!s.empty()){
    //     s.insert(s.begin(), words[i]);
    //   }
    //   dict[words[i]] = s;
    // }
}

/**
 * Constructs an AnagramDict from a vector of words.
 * @param words The vector of strings to be used as source words.
 */
AnagramDict::AnagramDict(const vector<string>& words)
{
    /* Your code goes here! */
    // method 1:
    // for (size_t i = 0; i < words.size(); i++){
    //   vector<string> s;
    //   for (size_t j = 0; j < words.size(); j++){
    //     if (i == j)
    //       continue;
    //     if (is_anagram(words[i], words[j])){
    //       s.push_back(words[j]);
    //     }
    //   }
    //   if (!s.empty()){
    //     s.insert(s.begin(), words[i]);
    //   }
    //   dict[words[i]] = s;
    // }
    // method 2:
    for (string str : words){
      string strsort = stringsort(str);
      map<string, vector<string>>::const_iterator lookup = dict.find(strsort);
      if (lookup == dict.end()){
        vector<string> v_string;
        v_string.push_back(str);
        dict[strsort] = v_string;
      }
      else{
        dict[strsort].push_back(str);
      }
    }
    // for (auto elem : dict){
    //   cout << elem.first << " ";
    //   for (string s : elem.second)
    //     cout << s << " ";
    //   cout << endl;
    // }
}


// helper function
bool AnagramDict::is_anagram(const string& word1, const string& word2) const
{
    string w1 = stringsort(word1);
    string w2 = stringsort(word2);
    return (w1 == w2);
}

// helper function to sort a string
string AnagramDict::stringsort(const string& word) const
{
  string w = word;
  std::sort(w.begin(), w.end());
  return w;
}


/**
 * @param word The word to find anagrams of.
 * @return A vector of strings of anagrams of the given word. Empty
 * vector returned if no anagrams are found or the word is not in the
 * word list.
 */
vector<string> AnagramDict::get_anagrams(const string& word) const
{
    /* Your code goes here! */
    // method 1:
    // map<string, vector<string>>::const_iterator lookup = dict.find(word);
    // if (lookup == dict.end())
    //   return vector<string>();
    // else
    //   return dict.at(word);
    // method 2:
    string w = stringsort(word);
    map<string, vector<string>>::const_iterator lookup = dict.find(w);
    if (lookup == dict.end())
      return vector<string>();
    else
      return dict.at(w);
}

/**
 * @return A vector of vectors of strings. Each inner vector contains
 * the "anagram siblings", i.e. words that are anagrams of one another.
 * NOTE: It is impossible to have one of these vectors have less than
 * two elements, i.e. words with no anagrams are ommitted.
 */
vector<vector<string>> AnagramDict::get_all_anagrams() const
{
    /* Your code goes here! */
    vector<vector<string>> ret;
    // method 1:
    // for (auto elem : dict)
    //   if (elem.second.empty())
    //     continue;
    //   else{
    //     ret.push_back(elem.second);
    //   }
    // method 2:
    for (auto elem : dict){
      if (elem.second.size() >= 2){
        ret.push_back(elem.second);
      }
    }

    return ret;
}
