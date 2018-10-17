/**
 * @file NimLearner.cpp
 * CS 225: Data Structures
 */

#include "NimLearner.h"
#include <ctime>


/**
 * Constructor to create a game of Nim with `startingTokens` starting tokens.
 *
 * This function creates a graph, `g_` representing all of the states of a
 * game of Nim with vertex labels "p#-X", where:
 * - # is the current player's turn; p1 for Player 1, p2 for Player2
 * - X is the tokens remaining at the start of a player's turn
 *
 * For example:
 *   "p1-4" is Player 1's turn with four (4) tokens remaining
 *   "p2-8" is Player 2's turn with eight (8) tokens remaining
 *
 * All legal moves between states are created as edges with initial weights
 * of 0.
 *
 * @param startingTokens The number of starting tokens in the game of Nim.
 */
NimLearner::NimLearner(unsigned startingTokens) : g_(true, true) {
  unsigned vertex_number = 2 * (startingTokens + 1);
  vector<string> name_v;
  for (unsigned i = 0; i < vertex_number; i+=2)
  {
      std::stringstream p1;
      std::stringstream p2;
      p1 << "p2" << "-" << startingTokens-i/2;
      p2 << "p1" << "-" << startingTokens-i/2;
      name_v.push_back(p1.str());
      name_v.push_back(p2.str());
      g_.insertVertex(p1.str());
      g_.insertVertex(p2.str());
  }

  // startingVertex_ = g_.getVertexByLabel("p1-" + std::to_string(startingTokens));
  for(unsigned i =0; i<vertex_number;i++){
    g_.insertVertexByLabel(name_v[i]);
  }
  // for (unsigned i = 0; i < vertex_number - 4; i+=2)
  // {
  //         g_.insertEdge(g_.getVertexByLabel(name_v[i]), g_.getVertexByLabel(name_v[i+3]));
  //         g_.setEdgeWeight(g_.getVertexByLabel(name_v[i]), g_.getVertexByLabel(name_v[i+3]), 0);
  //         g_.insertEdge(g_.getVertexByLabel(name_v[i]), g_.getVertexByLabel(name_v[i+5]));
  //         g_.setEdgeWeight(g_.getVertexByLabel(name_v[i]), g_.getVertexByLabel(name_v[i+5]), 0);
  //         g_.insertEdge(g_.getVertexByLabel(name_v[i+1]), g_.getVertexByLabel(name_v[i+2]));
  //         g_.setEdgeWeight(g_.getVertexByLabel(name_v[i+1]), g_.getVertexByLabel(name_v[i+2]), 0);
  //         g_.insertEdge(g_.getVertexByLabel(name_v[i+1]), g_.getVertexByLabel(name_v[i+4]));
  //         g_.setEdgeWeight(g_.getVertexByLabel(name_v[i+1]), g_.getVertexByLabel(name_v[i+4]), 0);
  // }
  // g_.insertEdge(g_.getVertexByLabel(name_v[vertex_number - 4]), g_.getVertexByLabel(name_v[vertex_number - 1]));
  // g_.setEdgeWeight(g_.getVertexByLabel(name_v[vertex_number - 4]), g_.getVertexByLabel(name_v[vertex_number - 1]), 0);
  // g_.insertEdge(g_.getVertexByLabel(name_v[vertex_number - 3]), g_.getVertexByLabel(name_v[vertex_number - 2]));
  // g_.setEdgeWeight(g_.getVertexByLabel(name_v[vertex_number - 3]), g_.getVertexByLabel(name_v[vertex_number - 2]), 0);
  //
  //   /* Your code goes here! */
  for (unsigned i=0; i<vertex_number-4; i++){
      if (i%2 == 0){
          g_.insertEdge(g_.getVertexByLabel(name_v[i]), g_.getVertexByLabel(name_v[i+3]));
          g_.setEdgeWeight(g_.getVertexByLabel(name_v[i]), g_.getVertexByLabel(name_v[i+3]), 0);
          g_.insertEdge(g_.getVertexByLabel(name_v[i]), g_.getVertexByLabel(name_v[i+5]));
          g_.setEdgeWeight(g_.getVertexByLabel(name_v[i]), g_.getVertexByLabel(name_v[i+5]), 0);
      }
      else{
          g_.insertEdge(g_.getVertexByLabel(name_v[i]), g_.getVertexByLabel(name_v[i+1]));
          g_.setEdgeWeight(g_.getVertexByLabel(name_v[i]), g_.getVertexByLabel(name_v[i+1]), 0);
          g_.insertEdge(g_.getVertexByLabel(name_v[i]), g_.getVertexByLabel(name_v[i+3]));
          g_.setEdgeWeight(g_.getVertexByLabel(name_v[i]), g_.getVertexByLabel(name_v[i+3]), 0);

      }
  }
  g_.insertEdge(g_.getVertexByLabel(name_v[vertex_number-4]), g_.getVertexByLabel(name_v[vertex_number-1]));
  g_.setEdgeWeight(g_.getVertexByLabel(name_v[vertex_number-4]), g_.getVertexByLabel(name_v[vertex_number-1]), 0);
  g_.insertEdge(g_.getVertexByLabel(name_v[vertex_number-3]), g_.getVertexByLabel(name_v[vertex_number-2]));
  g_.setEdgeWeight(g_.getVertexByLabel(name_v[vertex_number-3]), g_.getVertexByLabel(name_v[vertex_number-2]), 0);
  startingVertex_ = g_.getVertexByLabel("p1-"+to_string(startingTokens));
}

/**
 * Plays a random game of Nim, returning the path through the state graph
 * as a vector of `Edge` classes.  The `origin` of the first `Edge` must be
 * the vertex with the label "p1-#", where # is the number of starting
 * tokens.  (For example, in a 10 token game, result[0].origin must be the
 * vertex "p1-10".)
 *
 * @returns A random path through the state space graph.
 */
std::vector<Edge> NimLearner::playRandomGame() const {
  vector<Edge> path;
 /* Your code goes here! */
  Vertex now_ = startingVertex_;
  for (int i = 0; g_.getAdjacent(now_).size()>0;i++){
    vector<Vertex> around = g_.getAdjacent(now_);
    int aroundrange = around.size();
    Vertex nextone = around[rand()%aroundrange];
    Edge e = g_.getEdge(now_, nextone);
    path.push_back(e);
    now_ = nextone;
  }
  return path;
}

/*
 * Updates the edge weights on the graph based on a path through the state
 * tree.
 *
 * If the `path` has Player 1 winning (eg: the last vertex in the path goes
 * to Player 2 with no tokens remaining, or "p2-0", meaning that Player 1
 * took the last token), then all choices made by Player 1 (edges where
 * Player 1 is the source vertex) are rewarded by increasing the edge weight
 * by 1 and all choices made by Player 2 are punished by changing the edge
 * weight by -1.
 *
 * Likewise, if the `path` has Player 2 winning, Player 2 choices are
 * rewarded and Player 1 choices are punished.
 *
 * @param path A path through the a game of Nim to learn.
 */
void NimLearner::updateEdgeWeights(const std::vector<Edge> & path) {
 /* Your code goes here! */
 string loser = g_.getVertexLabel(path[path.size()-1].dest);
 if ( loser == "p2-0")
 {
     for (unsigned i = 0; i < path.size(); i++)
     {
         Vertex begin = path[i].source;
         Vertex dest = path[i].dest;
         if (i % 2 == 1)
         {
             g_.setEdgeWeight(begin, dest, g_.getEdgeWeight(begin, dest)-1);

         }
         else
         {
             g_.setEdgeWeight(begin, dest, g_.getEdgeWeight(begin, dest)+1);
         }
     }
 }
 else{
     for (unsigned i = 0; i < path.size(); i++)
     {
         Vertex begin = path[i].source;
         Vertex dest = path[i].dest;
         if (i % 2 == 1)
         {
             g_.setEdgeWeight(begin, dest, g_.getEdgeWeight(begin, dest)+1);

         }
         else
         {
             g_.setEdgeWeight(begin, dest, g_.getEdgeWeight(begin, dest)-1);
         }
     }
 }
}

/**
 * Label the edges as "WIN" or "LOSE" based on a threshold.
 */
void NimLearner::labelEdgesFromThreshold(int threshold) {
  for (const Vertex & v : g_.getVertices()) {
    for (const Vertex & w : g_.getAdjacent(v)) {
      int weight = g_.getEdgeWeight(v, w);

      // Label all edges with positve weights as "WINPATH"
      if (weight > threshold)           { g_.setEdgeLabel(v, w, "WIN"); }
      else if (weight < -1 * threshold) { g_.setEdgeLabel(v, w, "LOSE"); }
    }
  }
}

/**
 * Returns a constant reference to the state space graph.
 *
 * @returns A constant reference to the state space graph.
 */
const Graph & NimLearner::getGraph() const {
  return g_;
}
