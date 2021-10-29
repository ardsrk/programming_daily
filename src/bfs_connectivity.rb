# Find connected components of an undirected graph
# using breadth first search alogrithm
# 
# References:
#   https://www.youtube.com/watch?v=vHqaiQlOzOw

GRAPH = {
  1 => [3, 5],
  2 => [4],
  3 => [1, 5],
  4 => [2],
  5 => [1, 3, 7, 9],
  6 => [8, 10],
  7 => [5],
  8 => [6, 10],
  9 => [5],
  10 => [6, 8]
}

PARENT = {}
EXPLORED = {}
QUEUE = []

def bfs(v)
  EXPLORED[v] = true
  QUEUE.push(v)
  while(q = QUEUE.shift)
    GRAPH[q].each do |w|
      unless EXPLORED[w]
        EXPLORED[w] = true
        PARENT[w] = q
        QUEUE.push(w)
      end
    end
  end
end

GRAPH.keys.each do |v|
  bfs(v)
end

roots = GRAPH.keys.select {|v| PARENT[v].nil?}
puts "Graph has #{roots.size} connected components rooted at: #{roots}"
