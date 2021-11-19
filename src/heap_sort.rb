# Heapsort Algorithm
# 
# References
#   https://www.youtube.com/watch?v=6VI5kJu8Mv4
#   https://github.com/florian/rb_heap/blob/master/lib/rb_heap/heap.rb

# In a heap with one-based index the parent of ith element
# is i/2.
#
# Since we are using a zero-based array the parent of ith element
# is (i-1)/2.
def insert(h, number)
  h << number
  index = h.count-1
  while(index > 0 && h[(index-1)/2] > h[index])
    h[(index-1)/2], h[index] = h[index], h[(index-1)/2]
    index = (index-1)/2
  end
end

# In a heap with one-based index left child of ith element is 2i and
# right child is 2i + 1
#
# Since we are using zero-based array to implement heap the left child
# of ith element is 2i + 1 and the right child is 2i + 2
def extract_min(h)
  min = h[0]
  if h.count == 1
    h.pop
  else
    h[0] = h.pop
  end
  index = 0
  while(index*2+1 < h.count)
    el = h[index]
    li = index*2+1
    ri = index*2+2 if index*2+2 < h.count
    if(el > h[li]) || (ri && el > h[ri])
      pos = li
      if(ri && h[ri] < h[li])
        pos = ri
      end
      h[index], h[pos] = h[pos], h[index]
      index = pos
    else
      break
    end
  end
  min
end

input = [3, 8, 2, 5, 1, 4, 7, 6]
puts "Input: #{input}"

heap = []
input.each do |num|
  insert(heap, num)
end
puts "Heap: #{heap}"

output = []
while(heap.count > 0)
  output << extract_min(heap)
end
puts "Output: #{output}"
