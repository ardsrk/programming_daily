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
#
# Input: Weighted Directed Graph
#
# Output: 
#   Shortest path costs from a single vertex to all
#   other vertices arranged by number of edges in the path. 

# set of vertices
V = ['s', 't', 'v', 'w', 'x']

G = {
  's' => {'v' => 2, 'x' => 4},
  'v' => {'x' => 1, 'w' => 2},
  'x' => {'t' => 4},
  'w' => {'t' => 2},
}

start = 's'

# The cost of going from vertex s to vertex s using 0 edges is zero.
#
# Likewise, the cost of going from vertex s to vertex x using one edge is 4.
#   A[[1, 'x']] = 4
#
# While the cost of going from vertex s to vertex x using two edges is 3.
#   A[[2, 'x']] = 3
A = {[0, start] => 0}

0.upto(V.length-1) do |i|
  V.each do |v|
    next if v == start
    V.each do |w|
      next if w == v
      if G[w] && G[w][v] && !A[[i-1, w]].nil?
        new_cost = A[[i-1, w]] + G[w][v]
        if A[[i, v]].nil? || new_cost < A[[i, v]]
          A[[i, v]] = new_cost
        end
      end
    end
  end
end

puts "Input Graph:"

p G

puts ""
puts "Shortest Paths from #{start} by number of edges: "
0.upto(V.length-1).each do |i|
  print " " if i == 0
  print "#{'%3d' % i}"
end

puts ""

V.each do |v|
  print "#{v}"
  0.upto(V.length-1).each do |i|
    if A[[i, v]]
      print "#{'%3d' % A[[i,v]]}"
    else
      print "  x"
    end
  end
  puts ""
end
puts ""
