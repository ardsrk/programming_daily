# Given a weighted graph, Kruskal's minimum spanning tree algorithm finds the tree that spans
# all the vertices and has the minimum cost.
#
# The union find data-structure is used to reduce the polynomial time ( O(mn) ) for cycle-checking into
# constant time ( O(1) ).
#
# Assumptions
#   1. The input graph is connected
#   2. Edge costs are distinct
#
# References:
#   https://www.youtube.com/watch?v=fItEZEVyJKE   
#   https://www.youtube.com/watch?v=jY-vY6d18W4

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

# This map enables checking for cycles in constant time
# An entry like {'a' => 'b'} means that the 'b' is the leader of 'a'
# 
# Invariant:
#   1. Each vertex points to the leader of its component
LEADER = Hash[V.collect do |v|
  [v, v]
end]

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
  LEADER[a] == LEADER[b]
end

def find_followers(v)
  LEADER.select do |f, l|
    l == v
  end.keys
end

# update_leaders method maintains the invariant of LEADER map when
# vertex a and b belonging to different components become a single component
# when the edge (a,b) is added to the minimum spanning tree T
def update_leaders(a, b)
  la = LEADER[a]
  lb = LEADER[b]
  if !la && !lb
    LEADER[b] = a
    LEADER[a] = a
  elsif !la && lb
    LEADER[a] = lb
  elsif la && !lb
    LEADER[b] = la
  elsif la && lb && la != lb
    fa = find_followers(la)
    fb = find_followers(lb)
    if fa.count < fb.count
      fa.each do |v|
        LEADER[v] = lb
      end
    else
      fb.each do |v|
        LEADER[v] = la
      end
    end
  end
end

sort_edges_by_cost

# The main loop that implements kruskal's algorithm. 
# An edge is included into T if it does not introduce a cycle.
COSTS.each do |cost|
  src, dest = COST_VERTEX_MAP[cost]
  unless path_exists?(src, dest)
    (T[src] ||= {}).merge!(dest => cost)
    (T[dest] ||= {}).merge!(src => cost)
    update_leaders(src, dest)
    puts "Tree after adding #{src} <-> #{dest}: #{T}" if $DEBUG
    puts "LEADER: #{LEADER}" if $DEBUG
  end
end

require 'pp'

puts "Input graph G:"
pp G
puts ""
puts "Minimum Spanning tree of G:"
pp T
