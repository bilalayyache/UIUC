/**
 * @file quackfun.cpp
 * This is where you will implement the required functions for the
 *  stacks and queues portion of the lab.
 */

namespace QuackFun {

/**
 * Sums items in a stack.
 * @param s A stack holding values to sum.
 * @return The sum of all the elements in the stack, leaving the original
 *  stack in the same state (unchanged).
 *
 * @note You may modify the stack as long as you restore it to its original
 *  values.
 * @note You may use only two local variables of type T in your function.
 *  Note that this function is templatized on the stack's type, so stacks of
 *  objects overloading the + operator can be summed.
 * @note We are using the Standard Template Library (STL) stack in this
 *  problem. Its pop function works a bit differently from the stack we
 *  built. Try searching for "stl stack" to learn how to use it.
 * @hint Think recursively!
 */
  template <typename T>
  T sum(stack<T>& s)
  {

    // Your code here
    // base case
    if (s.empty())
      return T();
    // recuresive case
    T TOP = s.top();
    s.pop();
    T SUM = TOP + sum(s);
    s.push(TOP);
    return SUM;
                // stub return value (0 for primitive types). Change this!
                // Note: T() is the default value for objects, and 0 for
                // primitive types
  }

/**
 * Checks whether the given string (stored in a queue) has balanced brackets.
 * A string will consist of
 * square bracket characters, [, ], and other characters. This function will return
 * true if and only if the square bracket characters in the given
 * string are balanced. For this to be true,
 * all brackets must be matched up correctly, with no extra, hanging, or unmatched
 * brackets. For example, the string "[hello][]" is balanced, "[[][[]a]]" is balanced,
 * "[]]" is unbalanced, "][" is unbalanced, and "))))[cs225]" is balanced.
 *
 * You are allowed only the use of one stack in this function, and no other local variables.
 *
 * @param input The queue representation of a string to check for balanced brackets in
 * @return Whether the input string had balanced brackets
 */
  bool isBalanced(queue<char> input)
  {

    // @TODO: Make less optimistic
    stack<char> s;
    while (!input.empty()){
      if (input.front() == '[')
        s.push('[');
      else if (input.front() == ']' && s.empty())
        return false;
      else if (input.front() == ']' && !s.empty())
        s.pop();
      input.pop();
    }
    if (s.empty())
      return true;
    else
      return false;
  }

/**
 * Reverses even sized blocks of items in the queue. Blocks start at size
 * one and increase for each subsequent block.
 * @param q A queue of items to be scrambled
 *
 * @note Any "leftover" numbers should be handled as if their block was
 *  complete.
 * @note We are using the Standard Template Library (STL) queue in this
 *  problem. Its pop function works a bit differently from the stack we
 *  built. Try searching for "stl stack" to learn how to use it.
 * @hint You'll want to make a local stack variable.
 */
  template <typename T>
  void scramble(queue<T>& q)
  {
    stack<T> s1;
    queue<T> q1;
    // Your code here
    int size = q.size();

    // algorithm: when we need to store data in origin order, we push them into q1
    // When we need to reverse the order, we first push them into s1, and pop them out to push to q1
    // finally push all members in q1 back to q
    // total number of elements is size
    for (int i = 1; i <= size; i++){
      if (q.empty())
        break;
      if (i%2 == 1){
        // keep the origin order
        for (int k = 0; k < i; k++){
          if (!q.empty()){
            q1.push(q.front());
            q.pop();
          }
        }
      }

      else{
        // reverse the order
        for (int k = 0; k < i; k++){
          if (!q.empty()){
            s1.push(q.front());
            q.pop();
          }
        }
        // store the variable back to q1
        for (int k = 0; k < i; k++){
          if (!s1.empty()){
            q1.push(s1.top());
            s1.pop();
          }
        }
      }
    }
    for (int i = 0; i < size; i++){
      q.push(q1.front());
      q1.pop();
    }

  }

/**
 * @return true if the parameter stack and queue contain only elements of
 *  exactly the same values in exactly the same order; false, otherwise.
 *
 * @note You may assume the stack and queue contain the same number of items!
 * @note The back of the queue corresponds to the top of the stack!
 * @note There are restrictions for writing this function.
 * - Your function may not use any loops
 * - In your function you may only declare ONE local boolean variable to use in
 *   your return statement, and you may only declare TWO local variables of
 *   parametrized type T to use however you wish.
 * - No other local variables can be used.
 * - After execution of verifySame, the stack and queue must be unchanged. Be
 *   sure to comment your code VERY well.
 */
  template <typename T>
  bool verifySame(stack<T>& s, queue<T>& q)
  {
    // You may assume the stack and queue contain the same number of items!
    // The back of the queue corresponds to the top of the stack!
    bool retval = true; // optional
    T temp1; // rename me
    T temp2; // rename :)

    // Your code here
    // base case
    // if there is nothing in s, return true
    if (s.empty())
      return true;
    // recursive case
    else{
      // every recursion step, use temp1 to hold the value in s
      // after pop all the value from s, compare
      temp1 = s.top();
      s.pop();
      retval = verifySame(s, q);
      temp2 = q.front();
      // if current top of s is not front of q, return false
      if (temp1 != temp2)
        retval = false;
      // push back temp1 to s and push temp2 to the back of q
      // after pop and push all the values in q, we recover the queue
      s.push(temp1);
      q.pop();
      q.push(temp2);
    }
    return retval;
  }

}
