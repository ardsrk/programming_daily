# Extended Euclid's algorithm
#
# Problem:
#   Given two integers a and b, find two other integers x and y such that:
#
#     ax + by = gcd(a, b)
#
# References:
#   https://www.geeksforgeeks.org/euclidean-algorithms-basic-and-extended/

def xgcd(a, b)
  if a == 0
    return b, 0, 1
  end
  gcd, x1, y1 = xgcd(b%a, a)
  x = y1 - (b/a).to_i * x1
  y = x1
  return gcd, x, y
end

if __FILE__ == $0
  gcd, x, y = xgcd(30, 20)
  puts "30x + 20y = #{gcd}; x = #{x}; y = #{y}"

  gcd, x, y = xgcd(1432, 123211)
  puts "1432x + 123211y = #{gcd}; x = #{x}; y = #{y}"
end
