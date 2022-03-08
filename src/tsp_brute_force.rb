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
  'd' => {'a' => 3, 'b' => 2, 'c' => 6},
}

# set of edges in tour
t = {}

# cost of tour
cost = nil

require_relative './permutation'

permutation(V[1..-1]) do |vertices|
  s = 'a'
  tcost = 0
  result = {}
  (vertices + ['a']).each do |vertex|
    (result[s] ||= {}).merge!({vertex => G[s][vertex]})
    tcost += G[s][vertex]
    s = vertex
  end
  if cost.nil? || tcost < cost
    cost = tcost
    t = result
  end
end

require 'pp'
puts "Input Graph:"
pp G
puts "Tour Cost (minimum): #{cost}"
puts "Tour: "
pp t
