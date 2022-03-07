# Travelling Salesman Problem:
#  Given a complete undirected graph, G, output a tour with minimum total edge cost
#
# Input: Complete weighted undirected graph G
#
# Output: Tour of G having minimum total edge cost
#
# Solution: Find the tour have minimum total edge cost by exhaustive search

# set of vertices
V = ['a', 'b', 'c', 'd']

G = {
  'a' => {'b' => 1, 'c' => 4, 'd' => 3},
  'b' => {'a' => 1, 'c' => 5, 'd' => 2},
  'c' => {'a' => 4, 'b' => 5, 'd' => 6},
  'd' => {'a' => 3, 'b' => 2, 'd' => 6},
}
