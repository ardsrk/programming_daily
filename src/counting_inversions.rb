# Inversion in an array a occurs at index i and j when 
# a[i] > a[j] and i < j 

# input = [1, 3, 5, 2, 4, 6]
# l = [1, 3, 5]
# r = [2, 4, 6]
# merge_inversions counts the inversions occuring across the boundary
# There are three inversions: (3, 2), (5, 2), and (5, 4)
def merge_inversions(l, r, inv)
  i = 0
  j = 0
  result = []
  while i < l.count && j < r.count
    if l[i] <= r[j]
      result.append(l[i])
      i = i + 1
    else
      result.append(r[j])
      j = j + 1
      inv = inv + (l.count - i)
    end
  end

  if i < l.count
    result.concat(l[i..-1])
  end

  if j < r.count
    result.concat(r[j..-1])
  end
  return result, inv
end

def count_inversions(a, inv=0)
  p "ci: #{a}"
  if a.count <= 1
    return a, 0 
  else
    mid = a.count / 2
    l, inv = count_inversions(a[0...mid], inv) 
    r, inv = count_inversions(a[mid..-1], inv)
    merge_inversions(l, r, inv)
  end
end

input = [1, 3, 5, 2, 4, 6]
_, inv = count_inversions(input)
puts "Array #{input} has #{inv} inversions"
