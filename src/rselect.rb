# Random selection Algorithm
# Run with -d flag for debug output

# Reference:
#   https://www.youtube.com/watch?v=rX2u2CnpveQ

def partition(a, r)
  pivot = a[0]
  i = 1
  j = 1

  # Invariants
  #   1. Values between 1 and i are less than pivot
  #   2. Values between i and j-1 are greater than pivot
  #   3. Values between j and r are unknown

  while j <= r
    if a[j] < pivot
      a[i], a[j] = a[j], a[i]
      i = i + 1
    end
    j = j + 1
  end

  a[0], a[i-1] = a[i-1], a[0]
  i-1
end

# Randomly choose a pivot
def choose_pivot(a, r)
  pivot_idx = rand(r)
  a[pivot_idx], a[0] = a[0], a[pivot_idx]
end

def rselect(a, n, i)
  puts "rselect(#{a}, #{n}, #{i})" if $DEBUG
  if a.count == 1
    return a[0]
  else
    choose_pivot(a, n)
    pi = partition(a, n)
    if pi == i
      return a[pi]
    elsif pi > i
      rselect(a[0...pi], pi-1, i)
    else
      rselect(a[pi+1..-1], n-pi-1, i-pi-1)
    end
  end
end

input = [96, 89, 73, 85, 55, 17, 32, 68, 46, 5]

puts "Input: #{input}"

print "Enter a number between 1 and 10: "

index = gets.chomp.to_i

puts "Number at position #{index} is #{rselect(input, input.count-1, index-1)}"
puts "Sorted input is #{input.sort}"
