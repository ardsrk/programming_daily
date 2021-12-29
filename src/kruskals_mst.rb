# Given a weighted graph, Kruskal's minimum spanning tree algorithm finds the tree that spans
# all the vertices and has the minimum cost.
#
# Assumptions
#   1. The input graph is connected
#   2. Edge costs are distinct
#
# References:
#   https://www.youtube.com/watch?v=SZuCspj5AJc
#   https://www.youtube.com/watch?v=fItEZEVyJKE   

# set of all vertices
V = ['a', 'b', 'c', 'd']

# weighted edges
G = {
  'a' => {'b' => 1, 'c' => 5, 'd' => 4, 'e' => 3},
  'b' => {'a' => 1, 'c' => 7},
  'c' => {'a' => 5, 'b' => 7, 'e' => 6},
  'd' => {'a' => 4, 'e' => 2},
  'e' => {'a' => 3, 'c' => 6, 'd' => 2}
}

# Hash with cost as key and the vertices they connect as values
# The entry {1 => ['a', 'b']} means the edge connecting the vertices
# "a" and "b" has cost 1.
COST_VERTEX_MAP = {}

# Sorted array of edge costs.
COSTS = []

# The minimum spanning tree
T = {}

# Populates the COST_VERTEX_MAP and COSTS array by iterating
# over the entries in graph G
def sort_edges_by_cost
  G.each do |src, edges|
    edges.each do |dest, cost|
      unless COST_VERTEX_MAP[cost]
        COSTS.push(cost)
        COST_VERTEX_MAP[cost] = [src, dest]
      end
    end
  end
  COSTS.uniq!
  COSTS.sort!
end

# Returns true is path between vertex a and b exists in 
# minimum spanning tree T
def path_exists?(a, b)
  explored = {}
  explored[a] = true
  queue = [a]
  while(v = queue.shift)
    next unless T[v]
    T[v].each do |w, cost|
      unless explored[w]
        explored[w] = true
        queue.push(w)
      end
    end
  end
  !!(explored[a] && explored[b])
end

sort_edges_by_cost

# The main loop that implements kruskal's algorithm. 
# An edge is included into T if it does not introduce a cycle.
COSTS.each do |cost|
  src, dest = COST_VERTEX_MAP[cost]
  unless path_exists?(src, dest)
    (T[src] ||= {}).merge!(dest => cost)
    (T[dest] ||= {}).merge!(src => cost)
    puts "Tree after adding #{src} <-> #{dest}: #{T}" if $DEBUG
  end
end

require 'pp'

puts "Input graph G:"
pp G
puts ""
puts "Minimum Spanning tree of G:"
pp T
