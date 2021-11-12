# Find strongly connected components in directed graphs
# using Kosaraju's alogrithm
#
# References:
#   https://www.youtube.com/watch?v=O98hLTYVN3c

# Output depends on the order of vertices
VERTICES = ('a'..'i').to_a.shuffle

GRAPH = {
  'a' => ['c'],
  'b' => ['a'],
  'c' => ['b'],
  'd' => ['b', 'f'],
  'e' => ['d'],
  'f' => ['e'],
  'g' => ['e', 'h'],
  'h' => ['i'],
  'i' => ['g']
}


## REVERSED_GRAPH = {
  #"c"=>["a"],
  #"a"=>["b"],
  #"b"=>["c", "d"],
  #"f"=>["d"],
  #"d"=>["e"],
  #"e"=>["f", "g"],
  #"h"=>["g"],
  #"i"=>["h"],
  #"g"=>["i"]
##}
def reverse(g)
  inverted = g.invert
  result = {}.tap do |h|
    inverted.each do |k, v|
      k.each do |el|
        (h[el] ||= []) << v
      end
    end
  end
end

def dfs(graph, v)
  $explored[v] = true
  graph[v].each do |w|
    unless $explored[w]
      dfs(graph, w)
    end
  end
  $t = $t + 1
  $pos[v] = $t
end


def set
  $t = 0
  $explored = {}
  $pos = {}
  $roots = []
end

def first_pass
  reversed = reverse(GRAPH)
  VERTICES.each do |v|
    unless $explored[v]
      dfs(reversed, v)
    end
  end
end

def dfs(graph, v)
  $explored[v] = true
  graph[v].each do |w|
    unless $explored[w]
      dfs(graph, w)
    end
  end
  $t = $t + 1
  $pos[v] = $t
end


set
first_pass
order = $pos.sort_by {|k, v| v}.map {|el| el[0]}.reverse
set

# Execute DFS on vertices in decreasing order of finishing times
order.each do |v|
  unless $explored[v]
    $roots << v
    dfs(GRAPH, v)
  end
end

puts "Graph has #{$roots.size} connected components rooted at: #{$roots}"
