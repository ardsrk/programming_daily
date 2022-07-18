# Travelling Salesman Problem:
#  Given a complete undirected graph, G, output a tour with minimum total edge cost
#
# Input: Complete weighted undirected graph G
#
# Output: Tour of G having minimum total edge cost
#
# Solution: Find the tour having minimum total edge cost by greedy search
#
# References:
#   https://www.youtube.com/watch?v=dYEWqrp-mho

# set of vertices
V = ['a', 'b', 'c', 'd', 'e']

G = {
  'a' => {'b' => 1, 'c' => 4, 'd' => 5, 'e' => 10},
  'b' => {'a' => 1, 'c' => 2, 'd' => 6, 'e' => 3},
  'c' => {'a' => 4, 'b' => 2, 'd' => 7, 'e' => 8},
  'd' => {'a' => 5, 'b' => 6, 'c' => 7, 'e' => 9},
  'e' => {'a' => 10, 'b' => 3, 'c' => 8, 'd' => 9},
}

# set of edges in tour
t = {}

# cost of tour
cost = nil

# total number of operations
ops = 0

s = start = 'a'
while t.keys.count < V.count
  min = nil
  vertex = nil
  G[s].each do |v, c|
    ops = ops + 1
    unless t.keys.include?(v)
      if min.nil? || min > c
        vertex = v
        min = c
      end
    end
  end
  ops = ops + 1
  if min.nil?
    (t[s] ||= {}).merge!({start => G[s][start]})
    cost = cost.to_i + G[s][start]
  else
    (t[s] ||= {}).merge!({vertex => G[s][vertex]})
    cost = cost.to_i + min
    s = vertex
  end
end

require 'pp'
puts "Input Graph:"
pp G
puts "\nTour Cost (minimum): #{cost}"
puts "\nTour: "
pp t

# Total number of operations is linear to the number of edges in graph G
puts "\nNumber of operations: #{ops}"
