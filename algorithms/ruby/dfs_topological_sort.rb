# Topologically sort GRAPH using depth first search algorithm
#
# Topological sorting of classes in a course ensures that
# you take a class after you have taken all the pre-requisite classes
#
# Reference:
#   https://www.youtube.com/watch?v=ozso3xxkVGU


GRAPH = {
  's' => ['v', 'w'],
  'v' => ['t'],
  'w' => ['t'],
  't' => []
}

POS = {}
EXPLORED = {}

$current_label = GRAPH.keys.count

def dfs(v)
  EXPLORED[v] = true
  GRAPH[v].each do |w|
    unless EXPLORED[w]
      dfs(w)
    end
  end
  POS[v] = $current_label
  $current_label = $current_label - 1
end

def dfs_loop
  GRAPH.keys.each do |v|
    unless EXPLORED[v]
      dfs(v)
    end
  end
end

dfs_loop

p POS.sort_by {|k, v| v}.map {|el| el[0]}
