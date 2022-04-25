# Travelling Salesman Problem:
#  Given a complete undirected graph, G, output a tour with minimum total edge cost
#
# Input: Complete weighted undirected graph G
#
# Output: Tour of G having minimum total edge cost
#
# Solution: Find the tour having minimum total edge cost by greedy search followed by 2opt change
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

Tour = Struct.new(:vertices, :costs) do 
  def total_cost
    costs.sum
  end

  def extend(vertex, cost)
    self.vertices << vertex
    self.costs << cost
  end

  def to_s
    vertices.each_with_index.inject({}) do |h, (v, i)|
      if(vertices[i+1])
        h.merge!(v => {vertices[i+1] => costs[i]})
      else
        h
      end
    end
  end

  def inspect
    to_s
  end
end

# start vertex
s = start = 'a'

# set of edges in tour
t = Tour.new(['a'], [])

# total number of operations
ops = 0

while t.vertices.count < V.count
  min = nil
  vertex = nil
  G[s].each do |v, c|
    ops = ops + 1
    unless t.vertices.include?(v)
      if min.nil? || min > c
        vertex = v
        min = c
      end
    end
  end
  t.extend(vertex, G[s][vertex])
  s = vertex
end
t.extend(start, G[s][start])


Edge = Struct.new(:src, :dest) do
  def two_change_allowed?(e)
    # allowed if there is no common vertex shared by the two edges
    ([self.src, self.dest] & [e.src, e.dest]).nil?
  end

  def valid?
    src && dest
  end

  def ==(e)
    self.src == e.src && self.dest == e.dest
  end
end

TwoChange = Struct.new(:e1, :e2) do
  def ==(tc)
    self.e1 == tc.e1 && self.e2 == tc.e2
  end

  def valid?
    e1.valid? && e2.valid?
  end
end

def generate_two_change(t, index)
  vertices = t.vertices[0...-1] + t.vertices[0...-1]
  src1 = vertices[index]
  dest1 = vertices[index+1]
  if dest1
    dest2 = vertices[index+2]
    src2 = vertices[index+3] if dest2
  end
  e1 = Edge.new(src1, dest1)
  e2 = Edge.new(src2, dest2)
  TwoChange.new(e1, e2)
end

def all_two_changes(t)
  changes = []
  total_two_changes = (V.count * (V.count-3)) / 2
  total_two_changes.times do |i|
    two_change = generate_two_change(t, i)
    if two_change.valid? && !changes.include?(two_change)
      changes << two_change
    end
  end
  changes
end

puts "Input Graph:"
pp G
puts "\nTour Cost (minimum): #{t.total_cost}"
puts "\nTour: "
p t

# Total number of operations is linear to the number of edges in graph G
puts "\nNumber of operations: #{ops}"
