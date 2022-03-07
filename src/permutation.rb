# Input: Array of n elements
# Output: Enumerator that outputs n! permutations
#
# Reference:
#   https://www.cs.utexas.edu/users/djimenez/utsa/cs3343/lecture25.html

def permutation(arr, i=0, &block)
  if i == arr.count
    yield arr
  else
    i.upto(arr.count-1) do |j|
      arr[i], arr[j] = arr[j], arr[i]
      permutation(arr, i+1, &block)
      arr[i], arr[j] = arr[j], arr[i]
    end
  end
end
