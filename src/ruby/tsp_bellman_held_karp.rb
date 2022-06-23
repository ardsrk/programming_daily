# Travelling Salesman Problem:
#  Given a complete undirected graph, G, output a tour with minimum total edge cost
#
# Input: Complete weighted undirected graph G
#
# Output: Minimum total cost of a travelling salesman tour of G
#
# Solution: Find the tour having minimum total edge cost using bellman-held-karp dynamic programming algorithm
#
# References:
#   https://www.youtube.com/watch?v=D8aHqaFa8GE
#   https://www.youtube.com/watch?v=9DwFwkAwnmY

# set of vertices
V = ['a', 'b', 'c', 'd', 'e']

# Complete weighted undirected graph
G = {
  'a' => {'b' => 1, 'c' => 4, 'd' => 5, 'e' => 10},
  'b' => {'a' => 1, 'c' => 2, 'd' => 6, 'e' => 3},
  'c' => {'a' => 4, 'b' => 2, 'd' => 7, 'e' => 8},
  'd' => {'a' => 5, 'b' => 6, 'c' => 7, 'e' => 9},
  'e' => {'a' => 10, 'b' => 3, 'c' => 8, 'd' => 9},
}

# See https://www.geeksforgeeks.org/power-set/
def subsets(set)
  result = []
  subset_count = 2**set.count
  subset_count.times do |bit|
    result.append([])
    current_set = result.last
    set.count.times do |i|
      if bit & (1 << i) > 0
        current_set.append(set[i])
      end
    end
  end
  result
end

A = {}
START = V[0]

V[1..-1].each do |v|
  A[[START, v]] = {}
  A[[START, v]][v] = G[START][v]
end

SUBSETS = subsets(V)

3.upto(V.count) do |n|
  sets = SUBSETS.select do |set|
    set.count == n && set.include?(START)
  end
  sets.each do |s|
    A[s] = {}
    (s-[START]).each do |j|
      min = nil
      (s-[START, j]).each do |k|
        cost = A[s-[j]][k] + G[k][j]
        if min.nil? || cost < min
          min = cost
        end
      end
      A[s][j] = min
    end
  end
end

min_cost = nil

V[1..-1].each do |j|
  tour_cost = A[V][j] + G[j][START]
  if min_cost.nil? || tour_cost < min_cost
    min_cost = tour_cost
  end
end

puts "Input Graph:"
pp G
puts "\n\nTour Cost (minimum): #{min_cost}\n\n"

puts "Cost Table:"

require 'pp'
pp A

#TODO: Construct the minimum cost TSP tour based on the cost table (A)
