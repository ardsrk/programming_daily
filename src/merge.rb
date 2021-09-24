# Merge two pre-sorted arrays a1 and a2 into result

a1 = 5.times.collect { rand(100) }.sort
a2 = 5.times.collect { rand(100) }.sort

i1 = 0
i2 = 0
result = []
while i1 < a1.count && i2 < a2.count
  if a1[i1] < a2[i2]
    result.append(a1[i1])
    i1 = i1 + 1
  else
    result.append(a2[i2])
    i2 = i2 + 1
  end
end

if i1 < a1.count
  result.concat(a1[i1..-1])
end

if i2 < a2.count
  result.concat(a2[i2..-1])
end

puts "a1            = #{a1}"
puts "a2            = #{a2}"
puts "merge(a1, a2) = #{result}"
puts "sorted        = #{result == result.sort}"
