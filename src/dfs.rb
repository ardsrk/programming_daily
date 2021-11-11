# Run depth-first-search algorithm on GRAPH
# 
# References:
#   https://www.youtube.com/watch?v=_9_VUNrWGUs

GRAPH = {
  's' => ['a', 'b'],
  'a' => ['c', 'b', 's'],
  'b' => ['s', 'a', 'd'],
  'c' => ['e', 'a', 'd'],
  'd' => ['e', 'c', 'b'],
  'e' => ['c', 'd'],
}

PARENT = {'s' => nil}
EXPLORED = {}

def dfs(v)
  EXPLORED[v] = true
  GRAPH[v].each do |w|
    unless EXPLORED[w]
      PARENT[w] = v
      dfs(w)
    end
  end
end

dfs('s')

p PARENT
