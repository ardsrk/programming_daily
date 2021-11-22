# Binary search tree that supports insert and search operations
#
# References:
#   https://www.youtube.com/watch?v=QNSAqmvu4ZQ

class BST

  attr_accessor :value, :left, :right

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
      end
    else
      if(right)
        right.insert(num)
      else
        self.right = self.class.new(num)
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
