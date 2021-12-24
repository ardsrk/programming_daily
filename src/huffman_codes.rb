# Huffman encoding is a greedy algorithm to encode given symbols into binary strings
# with the property that the length of the encoded string of an arbitrary
# string of symbols will be optimal.
#
# References:
#   https://www.youtube.com/watch?v=K3WZhFZT6Y0
#   https://www.youtube.com/watch?v=HESrV5VDu8c
#   https://www.youtube.com/watch?v=NM6FZB7IfS8
#
# Input: Symbols and their weights
# Output: Huffman codes for each symbol
# Run with -d flag to print debug information


class Tree
  attr_accessor :label, :weight, :left, :right, :code

  def initialize(label, weight)
    @label = label
    @weight = weight
    @left = nil
    @right = nil
    @code = ""
  end

  def <(t)
    self.weight < t.weight
  end

  def >(t)
    self.weight > t.weight
  end

  def init_codes
    if left
      left.code += self.code + "0"
      left.init_codes
    end
    if right
      right.code += self.code + "1"
      right.init_codes
    end
  end

  def leaves(result=[])
    if(!left && !right)
      result << self
    end
    if(left)
      left.leaves(result)
    end
    if(right)
      right.leaves(result)
    end
    result
  end

  def huffman_codes
    init_codes
    Hash[leaves.collect do |l|
      [l.label, l.code]
    end]
  end
end

class Heap
  attr_accessor :heap

  def initialize
    @heap = []
  end

  def count
    @heap.count
  end

  def pop
    @heap.pop
  end

  def insert(tree)
    self.heap << tree
    index = heap.count-1
    while(index > 0 && heap[(index-1)/2] > heap[index])
      heap[(index-1)/2], heap[index] = heap[index], heap[(index-1)/2]
      index = (index-1)/2
    end
  end

  def extract_min
    min = heap[0]
    if heap.count == 1
      heap.pop
    else
      heap[0] = heap.pop
    end
    index = 0
    while(index*2+1 < heap.count)
      el = heap[index]
      li = index*2+1
      ri = index*2+2 if index*2+2 < heap.count
      if(el > heap[li]) || (ri && el > heap[ri])
        pos = li
        if(ri && heap[ri] < heap[li])
          pos = ri
        end
        heap[index], heap[pos] = heap[pos], heap[index]
        index = pos
      else
        break
      end
    end
    min
  end
end

def merge_nodes(heap)
  while heap.count > 1
    n1 = heap.extract_min
    n2 = heap.extract_min
    puts "Merge #{n1.label} and #{n2.label}" if $DEBUG
    t = Tree.new("#{n1.label}:#{n2.label}", n1.weight+n2.weight)
    t.left = n2
    t.right = n1
    t.weight = n1.weight + n2.weight
    heap.insert(t)
  end
  heap.pop
end

def huffman_codes(input)
  nodes = input.collect do |k, v|
    Tree.new(k, v)
  end

  heap = Heap.new
  nodes.each do |node|
    heap.insert(node)
  end
  huffman_tree = merge_nodes(heap)
  huffman_tree.huffman_codes
end

def sort(codes)
  Hash[codes.sort_by{|k,v| k}]
end

input1 = {'A' => 0.6, 'B' => 0.25, 'C' => 0.1, 'D' => 0.05}
input2 = {'A' => 3, 'B' => 2, 'C' => 6, 'D' => 8, 'E' => 2, 'F' => 6}

puts "Symbols:       #{input1}"
puts "Huffman Codes: #{sort(huffman_codes(input1))}"
puts 
puts "Symbols:       #{input2}"
puts "Huffman Codes: #{sort(huffman_codes(input2))}"
