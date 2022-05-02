# References:
#   https://www.youtube.com/watch?v=zKRZsKhbkm4&list=PL-qvsLbZq06LvdO6L7byZfcigeQAEo2k6&index=20
#   https://www.khanacademy.org/computing/computer-science/cryptography/modarithmetic/a/the-euclidean-algorithm

require_relative './division_algorithm'

def gcd(a, b)
  if a == 0 && b == 0
    0
  elsif a == 0
    b
  elsif b == 0
    a
  else
    _, r = divide(a, b)
    gcd(b, r)
  end
end

if __FILE__ == $0
  puts "gcd(12, 8) = #{gcd(12, 8)}"
  puts "gcd(8, 12) = #{gcd(8, 12)}"
  puts "gcd(270, 192) = #{gcd(270, 192)}"
end
