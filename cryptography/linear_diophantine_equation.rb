# Solution to linear diophantine equation
# 
# Problem:
#   Given a equation like below:
#       
#       ax + by = c
#
#   Find x and y that solves the equation.
#
# Output:
#   Integers x and y that solves the equaton.
#
# References:
#   https://brilliant.org/wiki/linear-diophantine-equations-one-equation/
#   https://www.youtube.com/watch?v=yaaPTLZV6sE
#   https://www.youtube.com/watch?v=nB2XgdfbLwY

require_relative './euclid_extended_gcd'

def lde(a, b, c)
  d, x, y = xgcd(a, b)
  if c % d != 0
    return
  end
  q = (c / d).to_i
  return x*q, y*q
end

a = 21; b = 15; c = 12 
print "Equation: #{a}x + #{b}y = #{c}; "
x, y = lde(a, b, c)
if x.nil?
  puts "has no solution"
else
  puts "x=#{x}; y=#{y}"
end
puts 
a = 14; b = 91; c = 53 
print "Equation: #{a}x + #{b}y = #{c}; "
x, y = lde(a, b, c)
if x.nil?
  puts "has no solution"
else
  puts "x=#{x}; y=#{y}"
end
