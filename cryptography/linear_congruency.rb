# Solution to linear congruences
#
# Problem:
#   Given a congruence like below:
#       
#       ax = c (mod m)
#
#   Find all x that satisfies the congruence
#
# Output:
#   All integers x that satisfies the congruence.
#
# References:
#   https://www.youtube.com/watch?v=2K4LZ7fi1is


require_relative './linear_diophantine_equation'

def lc(a, c, m)
  d, x, _ = lde(a, m, c)
  if x.nil?
    []
  else
    d.times.collect do |i|
      (x + i * (m/d).to_i) % m
    end
  end
end

def print_solution_lc(a, c, m)
  print "Congruence: #{a}x = #{c} (mod #{m}); "
  r = lc(a, c, m)
  if r.count == 0
    puts "has no solution"
  else
    puts "x in [#{r.join(', ')}]"
  end
end

a = 4; c = 2; m = 6 
print_solution_lc(a, c, m)
puts
a = 2; c = 1; m = 4 
print_solution_lc(a, c, m)
