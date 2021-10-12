# Quicksort Algorithm
# Run with -d flag for debug output

# Reference:
#   https://www.youtube.com/watch?v=LYzdRN5iFdA

def partition(a, l, r)
  pivot = a[l]
  i = l + 1
  j = l + 1

  # Invariants
  #   1. Values between l+1 and i are less than pivot
  #   2. Values between i and j-1 are greater than pivot
  #   3. Values between j and r are unknown

  while j <= r
    if a[j] < pivot
      a[i], a[j] = a[j], a[i]
      i = i + 1
    end
    j = j + 1
  end

  a[l], a[i-1] = a[i-1], a[l]
  i-1
end

def qsort(a, l, r)
  puts "qsort(#{a}, #{l}, #{r})" if $DEBUG
  if l < r
    pi = partition(a, l, r)
    qsort(a, l, pi-1)
    qsort(a, pi+1, r)
  end
end

input = [3, 8, 2, 5, 1, 4, 7, 6]

puts "Input: #{input}"

qsort(input, 0, input.count-1)

# Sort happens in-place
output = input
puts "Output: #{output}"
