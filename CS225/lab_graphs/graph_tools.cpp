/**
 * @file graph_tools.cpp
 * This is where you will implement several functions that operate on graphs.
 * Be sure to thoroughly read the comments above each function, as they give
 *  hints and instructions on how to solve the problems.
 */

#include "graph_tools.h"
#include "dsets.h"

/**
 * Finds the minimum edge weight in the Graph graph.
 * THIS FUNCTION IS GRADED.
 *
 * @param graph - the graph to search
 * @return the minimum weighted edge
 *
 * @todo Label the minimum edge as "MIN". It will appear blue when
 *  graph.savePNG() is called in minweight_test.
 *
 * @note You must do a traversal.
 * @note You may use the STL stack and queue.
 * @note You may assume the graph is connected.
 *
 * @hint Initially label vertices and edges as unvisited.
 */
int GraphTools::findMinWeight(Graph& graph)
{
    //TODO: YOUR CODE HERE
    int min = INT_MAX;
    Vertex first, second;
    // vector<Edge> edge_vector = graph.getEdges();
    // for (Edge e : edge_vector){
    //   if (e.getWeight() < min){
    //     min_weight_edge = e;
    //     min = e.getWeight();
    //   }
    // }
    // graph.setEdgeLabel(min_weight_edge.source, min_weight_edge.dest, "MIN");
    // do BST traverse
    queue<Vertex> vertex_queue;
    Vertex start = graph.getStartingVertex();
    vertex_queue.push(start);
    graph.setVertexLabel(start, "VISITED");
    while (!vertex_queue.empty()){
      Vertex temp = vertex_queue.front();
      vertex_queue.pop();
      vector<Vertex> vertex_vector = graph.getAdjacent(temp);
      for (Vertex v : vertex_vector){
        // if v is unvisited, set edge as DISCOVERY
        if (graph.getVertexLabel(v) == ""){
          graph.setEdgeLabel(temp, v, "DISCOVERY");
          graph.setVertexLabel(v, "VISITED");
          vertex_queue.push(v);
          // update the minWeight
          if (graph.getEdgeWeight(v, temp) < min){
            first = v; second = temp;
            min = graph.getEdgeWeight(v, temp);
          }
        }
        else if (graph.getVertexLabel(v) == "VISITED"){
          graph.setEdgeLabel(v, temp, "CROSS");
          // update the minWeight
          if (graph.getEdgeWeight(v, temp) < min){
            first = v; second = temp;
            min = graph.getEdgeWeight(v, temp);
          }
        }
      }
    }
    // set the minWeight label
    graph.setEdgeLabel(first, second, "MIN");
    return min;
}

/**
 * Returns the shortest distance (in edges) between the Vertices
 *  start and end.
 * THIS FUNCTION IS GRADED.
 *
 * @param graph - the graph to search
 * @param start - the vertex to start the search from
 * @param end - the vertex to find a path to
 * @return the minimum number of edges between start and end
 *
 * @todo Label each edge "MINPATH" if it is part of the minimum path
 *
 * @note Remember this is the shortest path in terms of edges,
 *  not edge weights.
 * @note Again, you may use the STL stack and queue.
 * @note You may also use the STL's unordered_map, but it is possible
 *  to solve this problem without it.
 *
 * @hint In order to draw (and correctly count) the edges between two
 *  vertices, you'll have to remember each vertex's parent somehow.
 */
int GraphTools::findShortestPath(Graph& graph, Vertex start, Vertex end)
{
    //TODO: YOUR CODE HERE
    // do BST for finding the path
    // setup the queue for the traverse
    queue<Vertex> vertex_queue;
    vertex_queue.push(start);
    graph.setVertexLabel(start, "VISITED");
    // make a map that map each vertex with its distance from start and its predecessor
    unordered_map<Vertex, pair<int, Vertex>> vertex_map;
    vertex_map[start] = pair<int, Vertex>(0, "");
    while (!vertex_queue.empty()){
      Vertex temp = vertex_queue.front();
      vertex_queue.pop();
      vector<Vertex> vertex_vector = graph.getAdjacent(temp);
      for (Vertex v : vertex_vector){
        if (graph.getVertexLabel(v) == "VISITED")
          continue;
        vertex_queue.push(v);
        graph.setVertexLabel(v, "VISITED");
        // after getting the vertex, we add the vertex and its information to the map
        vertex_map[v] = pair<int, Vertex>(vertex_map[temp].first+1, temp);
      }

    }
    pair<int, Vertex> vertex_pair;
    vertex_pair = vertex_map[end];
    int ret = vertex_pair.first;
    // begin to find the minpath
    Vertex curr = end;
    Vertex prev = vertex_pair.second;
    while (prev != ""){
      graph.setEdgeLabel(curr, prev, "MINPATH");
      curr = prev;
      prev = vertex_map[curr].second;
    }
    return ret;
}

/**
 * Finds a minimal spanning tree on a graph.
 * THIS FUNCTION IS GRADED.
 *
 * @param graph - the graph to find the MST of
 *
 * @todo Label the edges of a minimal spanning tree as "MST"
 *  in the graph. They will appear blue when graph.savePNG() is called.
 *
 * @note Use your disjoint sets class from MP 7.1 to help you with
 *  Kruskal's algorithm. Copy the files into the dsets.h and dsets.cpp .
 * @note You may call std::sort instead of creating a priority queue.
 */

// helper function to compare two edges
bool GraphTools::smaller(Edge a, Edge b)
{
  return a.getWeight() < b.getWeight();
}

void GraphTools::findMST(Graph& graph)
{
    //TODO: YOUR CODE HERE
    vector<Edge> edge_vector = graph.getEdges();
    // sort the edges depend on their weight and make an edge list
    std::sort(edge_vector.begin(), edge_vector.end(), smaller);
    // from the algorithm, we need to first set a disjoint set
    // and union edges until all edges are connected
    DisjointSets disjset;
    vector<Vertex> vertex_vector = graph.getVertices();
    // use a map to map the vertex to index in int
    unordered_map<Vertex, int> vertex_map;
    int i = 0;
    for (Vertex v : vertex_vector){
      vertex_map[v] = i;
      i++;
    }
    disjset.addelements(i);
    i = 0;
    for (Edge e : edge_vector){
      int first = vertex_map[e.source];
      int second = vertex_map[e.dest];
      if (disjset.find(first) != disjset.find(second)){
        graph.setEdgeLabel(e.source, e.dest, "MST");
        disjset.setunion(first, second);
      }
    }
}
