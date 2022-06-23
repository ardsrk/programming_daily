# Computes shortest path to all vertices from given source vertex
# using Dijkstra's algorithm
#
# An application of this algorithm is to find the shortest route between
# two places in a network of roads
#
# Reference:
#   https://www.youtube.com/watch?v=jRlNVmRjdRk

# Set of all vertices
V = ['s', 'v', 'w', 't']

D = {
  's' => {'v' => 1, 'w' => 4},
  'v' => {'w' => 2, 't' => 6},
  'w' => {'t' => 3}
}

# Set of all vertices with known shortest paths
X = ['s']

# Shortest path values of every vertex in V
A = {'s' => 0}

# Hash with leading vertex as key and tail vertex as value
B = {'s' => nil}

# V-X is set of all vertices with unknown shortest paths
# Each call to get-min extends X by one vertex
#
# Return Values:
#   b: begin vertex ( in set X )
#   e: end vertex ( in set V-X )
#   w: Weight of path from 's' to d
def get_min
  b = nil
  e = nil
  w = nil
  X.each do |v|
    next if D[v].nil?
    D[v].each do |dest, wt|
      next if X.include?(dest)
      if w.nil? || w > A[v]+wt
        w = A[v] + wt
        e = dest
        b = v
      end
    end
  end
  [b, e, w]
end

while X.count != V.count
  b, e, w = get_min
  X << e
  B[e] = b
  A[e] = w
end

puts "Graph: #{D}"
puts "Shortest path values: #{A}"
puts "Shortest path route: #{B}"
