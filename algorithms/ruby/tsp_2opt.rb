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
#   https://www.youtube.com/watch?v=8vbKIfpDPJI

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

Tour = Struct.new(:vertices) do
  def total_cost
    all_vertices = vertices + [vertices[0]]
    all_vertices.each_with_index.inject(0) do |cost, (v, i)|
      if(i < all_vertices.count-1)
        cost = cost + G[v][all_vertices[i+1]]
      else
        cost
      end
    end
  end

  def dup
    super.tap do |t|
      t.vertices = self.vertices.dup
    end
  end

  def extend(vertex)
    self.vertices << vertex
  end

  def to_s
    all_vertices = vertices + [vertices[0]]
    all_vertices.each_with_index.inject({}) do |h, (v, i)|
      if(all_vertices[i+1])
        h.merge!(v => {all_vertices[i+1] => G[v][all_vertices[i+1]]})
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
greedy_tour = Tour.new(['a'])

# total number of operations
$ops = 0

while greedy_tour.vertices.count < V.count
  min = nil
  vertex = nil
  G[s].each do |v, c|
    $ops = $ops + 1
    unless greedy_tour.vertices.include?(v)
      if min.nil? || min > c
        vertex = v
        min = c
      end
    end
  end
  greedy_tour.extend(vertex)
  s = vertex
end

def generate_two_change(t, index)
  size = t.vertices.count
  pos1 = (index+1) % size
  pos2 = (index+2) % size
  t.dup.tap do |nt|
    vs = nt.vertices
    vs[pos1], vs[pos2] = vs[pos2], vs[pos1]
  end
end

def tsp_2opt(t)
  total_two_changes = (V.count * (V.count-3)) / 2
  min_tour = t
  loop do
    halt = true
    total_two_changes.times do |i|
      $ops = $ops + 1
      two_change_tour = generate_two_change(min_tour, i)
      if min_tour.total_cost > two_change_tour.total_cost
        halt = false
        min_tour = two_change_tour
        break
      end
    end
    break if halt
  end
  min_tour
end

min_tour = tsp_2opt(greedy_tour)

puts "Input Graph:"
pp G
puts "\nTour Cost (minimum): #{min_tour.total_cost}"
puts "\nTour: "
p min_tour

# number of operations depends on number of improving tours that generate_two_change can produce
puts "\nNumber of operations: #{$ops}"
