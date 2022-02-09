# Problem:
# Given a directed graph, find the single source shortest path from a given vertex to
# all other vertices.
# 
# Solutions:
#   1. Dijikstra's Algorithm
#   2. Bellman Ford Algorithm
#
# Limitations of Dijikstra:
#   1. Does not allow negative length edges
#   2. Centralized ( Not distributed ). Does not work at internet scale.
#
# Assumptions for Bellman-Ford:
#   1. Negative cycles not allowed

# set of vertices
V = ['s', 't', 'v', 'w', 'x']

G = {
  's' => {'v' => 2, 'x' => 4},
  'v' => {'x' => 1, 'w' => 2},
  'x' => {'t' => 4},
  'w' => {'t' => 2},
}
