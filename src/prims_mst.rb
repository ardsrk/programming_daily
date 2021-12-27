# Given a weighted graph, Prim's minimum spanning tree algorithm finds the tree that spans
# all the vertices and has the minimum cost.
#
# Assumptions
#   1. The input graph is connected
#   2. Edge costs are distinct
#
# References:
#   https://www.youtube.com/watch?v=tDj9BkaQDO8
#   https://www.youtube.com/watch?v=jsvOPssDVJA
#   https://www.youtube.com/watch?v=cDtQnXMZGtg
#   https://www.youtube.com/watch?v=jGR_LAwGLGk

# set of all vertices
V = ['a', 'b', 'c', 'd']

# weighted edges
G = {
  'a' => {'b' => 1, 'c' => 4, 'd' => 3},
  'b' => {'a' => 1, 'd' => 2},
  'c' => {'a' => 4, 'd' => 5},
  'd' => {'a' => 3, 'b' => 2, 'c' => 5}
}

# X is set of all vertices part of minimum spanning tree.
# V-X is the set of all vertices not part of minimum spanning tree.
# When X equals V, execution of algorithm is complete and T is the minimum spanning tree.
X = ['a']

# The minimum spanning tree
T = {}

# Finds the minimum cost edge to vertex `v` from a vertex in V-X
def get_min_edge_to(v)
  min = nil
  result = {}
  X.each do |x|
    if G[x][v] && (min.nil? || G[x][v] < min)
      min = G[x][v]
      result = {'src' => x, 'dest' => v, 'cost' => min}
    end
  end
  result
end

# Every entry in the heap is a hash with keys 'src', 'dest', and 'cost'.
# The value of key 'src' is the source vertex, value
# of key 'cost' is the cost of reaching the destination vertex ( which is
# the value of key 'dest' )
H = []

# Inserts the given entry into heap H
def insert_into_heap(entry)
  return if duplicate_entry?(entry)
  H << entry
  index = H.count-1
  while(index > 0 && H[(index-1)/2]['cost'] > H[index]['cost'])
    H[(index-1)/2], H[index] = H[index], H[(index-1)/2]
    index = (index-1)/2
  end
end

def duplicate_entry?(entry)
  result = H.find do |e|
    e['src'] == entry['src'] && e['dest'] == entry['dest'] &&
      e['cost'] == entry['cost']
  end
  !!result
end

# Maintains the property of min-heap, that is, value
# of element at parent node is smaller than the values at
# child nodes.
def heapify
  (H.count-1).downto(0) do |index|
    while(index > 0 && H[(index-1)/2]['cost'] > H[index]['cost'])
      H[(index-1)/2], H[index] = H[index], H[(index-1)/2]
      index = (index-1)/2
    end
  end
end

# Deletes entry in given index
def delete_from_heap(index)
  last_index = H.count-1
  if last_index == index
    H.pop
  else
    H[index], H[last_index] = H[last_index], H[index]
    H.pop
    heapify
  end
end

# The min-heap H that satisfies following invariants:
# 1. Entries of the heap contain vertices in V-X.
# 2. For each vertex in V-X, it stores the cheapest edge (u,v) with u in X and v in V-X.
def maintain_heap_invariants
  V.each do |v|
    unless X.include?(v)
      edge = get_min_edge_to(v)
      if edge
        insert_into_heap(edge)
      end
    end
  end
end

# Extracts the minimum cost edge from a vetex in set X to a vertex in set V-X
def extract_min
  min = H[0]
  if H.count == 1
    H.pop
  else
    H[0] = H.pop
  end
  index = 0
  while(index*2+1 < H.count)
    el = H[index]
    li = index*2+1
    ri = index*2+2 if index*2+2 < H.count
    if(el['cost'] > H[li]['cost']) || (ri && el['cost'] > H[ri]['cost'])
      pos = li
      if(ri && H[ri]['cost'] < H[li]['cost'])
        pos = ri
      end
      H[index], H[pos] = H[pos], H[index]
      index = pos
    else
      break
    end
  end
  min
end

# Delete stale entries in heap after extending the MST ( mininum span tree )
def delete_stale_entries
  while(index=find_stale_entry_index)
    delete_from_heap(index)
  end
end

def find_stale_entry_index
  result = H.index do |entry|
    X.include?(entry['src']) && X.include?(entry['dest'])
  end
  result
end

while X.count != V.count
  maintain_heap_invariants

  entry = extract_min
  src, dest, cost = entry['src'], entry['dest'], entry['cost']
  (T[src] ||= {}).merge!({dest => cost})
  X << dest
  puts "Tree after adding #{src} -> #{dest}: #{T}" if $DEBUG

  delete_stale_entries
end

require 'pp'
puts "Input graph G:"
pp G
puts ""
puts "Minimum Spanning tree of G:"
pp T
