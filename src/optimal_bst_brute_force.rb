# Find optimal cost BST ( binary search tree ) for given items with frequency
#
# Input: Items with frequency  
# Output: Optimal cost BST
#
# References:
#  https://www.youtube.com/watch?v=oYlJUTVklc8
#  https://www.youtube.com/watch?v=ihWm4GTVwmM
#  https://www.youtube.com/watch?v=9_U8RYsx5L4
#  https://www.geeksforgeeks.org/optimal-binary-search-tree-dp-24/

items = [10, 12, 20]

# Item 20 has cost 50
freqs = [34, 8, 50]

$cost_table = {}

def sum(freqs, i, j)
  s = 0
  i.upto(j) do |k|
    s = s + freqs[k]
  end
  s
end

def optimal_cost(items, freqs, i, j)
  return 0 if j < i
  return freqs[i] if j == i

  fsum = sum(freqs, i, j)
  min = nil
  root = nil

  i.upto(j) do |r|
    oc1 = optimal_cost(items, freqs, i, r-1)
    oc2 = optimal_cost(items, freqs, r+1, j)
    cost =  oc1 + oc2 
    if min.nil? || cost < min
      min = cost
      root = r
    end
  end
  $cost_table[[i, j]] = {root => min + fsum}
  min + fsum
end

def optimal_search_tree(items, freqs)
  optimal_cost(items, freqs, 0, items.count - 1)
end

require_relative "./binary_search_tree"

# Build BST by reading costs off from $cost_table
def build_tree(i, j, items, bst=nil, subtree=nil)
  root = $cost_table[[i, j]]
  if root
    root_idx = root.keys.pop
    node = BST.new(items[root_idx])
  end
  if node
    if bst
      bst.send("#{subtree}=", node)
    else
      bst = node
    end
    if root_idx && i < root_idx-1
      build_tree(i, root_idx-1, items, node, :left)
    elsif i == root_idx-1
      if items[i] < node.value
        node.left = BST.new(items[i])
      else
        node.right = BST.new(items[i])
      end
    end
    if root_idx && root_idx+1 < j
      build_tree(root_idx+1, j, items, node, :right)
    elsif root_idx+1 == j
      if items[j] < node.value
        node.left = BST.new(items[j])
      else
        node.right = BST.new(items[j])
      end
    end
    bst
  end
end

puts "Items       : #{items}"
puts "Frequencies : #{freqs}"
puts ""
puts "Optimal Cost: #{optimal_search_tree(items, freqs)}"
puts "Tree        : #{build_tree(0, items.count-1, items)}"
