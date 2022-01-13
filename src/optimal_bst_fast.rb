# Find optimal cost BST ( binary search tree ) for given items with frequency
#
# Uses dynamic programming to speed up calculation of optimal cost
#
# Input: Items with frequency  
# Output: Value of Optimal cost BST
#
# References:
#  https://www.youtube.com/watch?v=oYlJUTVklc8
#  https://www.youtube.com/watch?v=ihWm4GTVwmM
#  https://www.youtube.com/watch?v=9_U8RYsx5L4
#  https://www.geeksforgeeks.org/optimal-binary-search-tree-dp-24/
#
# Todo:
#  Construct optimal cost BST

items = [10, 12, 20]

# Item 20 has cost 50
freqs = [34, 8, 50]

def sum(freqs, i, j)
  s = 0
  i.upto(j) do |k|
    s = s + freqs[k].to_i
  end
  s
end

def optimal_search_tree(items, freqs)
  size = items.count
  cost = Array.new(size){Array.new(size)}

  0.upto(size-1) do |i|
    cost[i][i] = freqs[i]
  end

  0.upto(size-1) do |s|
    0.upto(size-1) do |i|
      next if i+s > size - 1
      cost[i][i+s] = i.upto(i+s).collect do |r|
        sum(freqs, i, i+s) + ((i > r-1) ? 0 : cost[i][r-1]) + ((r+1 > i+s) ? 0 : cost[r+1][i+s])
      end.min
    end
  end
  cost[0][size-1]
end

puts "Items       : #{items}"
puts "Frequencies : #{freqs}"
puts ""
puts "Optimal Cost: #{optimal_search_tree(items, freqs)}"
