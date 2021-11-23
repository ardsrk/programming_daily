# Binary search tree that supports insert and search operations
#
# References:
#   https://www.youtube.com/watch?v=QNSAqmvu4ZQ
#   https://www.youtube.com/watch?v=usq3dxJ2r5k

class BST

  attr_accessor :value, :left, :right, :parent

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end

  def insert(num)
    if(num < self.value)
      if(left)
        left.insert(num)
      else
        self.left = self.class.new(num)
        left.parent = self
      end
    else
      if(right)
        right.insert(num)
      else
        self.right = self.class.new(num)
        right.parent = self
      end
    end
  end

  def search(num)
    if(value == num)
      self
    elsif(num < value)
      left.search(num) if left
    else
      right.search(num) if right
    end
  end

  def min
    left ? left.min : value
  end

  def max
    right ? right.max : value
  end

  def pred(num)
    node = search(num)
    if(node.left)
      node = node.left
      while(node.right)
        node = node.right
      end
      node
    else
      node = node.parent
      while(node && node.value > num)
        node = node.parent
      end
      if node && node.value != num
        node
      end
    end
  end

  def succ(num)
    node = search(num)
    if(node.right)
      node = node.right
      while(node.left)
        node = node.left
      end
      node
    else
      node = node.parent
      while(node && node.value < num)
        node = node.parent
      end
      if node && node.value != num
        node
      end
    end
  end

  def to_s
    (left || "").to_s +
      "#{value.to_s} " +
      (right || "").to_s
  end
end

input = [3, 8, 2, 5, 1, 4, 7, 6]

bst = BST.new(input[0])
input[1..-1].each do |number|
  bst.insert(number)
end

puts "Input: #{input}"
puts ""
puts "Inorder traversal: #{bst}"
puts "Tree has number 7? #{bst.search(7) ? 'yes' : 'no'}"
puts "Tree has number 9? #{bst.search(9) ? 'yes' : 'no'}"
puts ""
puts "Minimum: #{bst.min}"
puts "Maximum: #{bst.max}"
puts ""
input.each do |num|
  puts "Predecessor of #{num}: #{pred = bst.pred(num); pred ? pred.value : "nil"}"
end

puts ""
input.each do |num|
  puts "Successor of #{num}: #{succ = bst.succ(num); succ ? succ.value : "nil"}"
end
