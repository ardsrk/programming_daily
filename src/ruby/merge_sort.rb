# Full merge-sort alogrithm
# Run with -d flag for debug output

def merge(a, b)
  puts "merge(#{a}, #{b})" if $DEBUG
  i = 0
  j = 0
  result = []
  while i < a.count && j < b.count
    if a[i] < b[j]
      result.append(a[i])
      i = i + 1
    else
      result.append(b[j])
      j = j + 1
    end
  end

  if i < a.count
    result.concat(a[i..-1])
  end

  if j < b.count
    result.concat(b[j..-1])
  end
  result
end

def sort(a)
  if a.count <= 1
    a
  else 
    mid = a.count / 2
    puts "merge(sort(#{a[0...mid]}), sort(#{a[mid..-1]}))" if $DEBUG
    merge(sort(a[0...mid]), sort(a[mid..-1]))
  end
end

input = 10.times.collect { rand(100) }
puts "Input: #{input}"
output = sort(input)
puts "Output: #{output}"

