# References:
#   https://www.youtube.com/watch?v=DATIpbqTOG4&list=PL-qvsLbZq06LvdO6L7byZfcigeQAEo2k6&index=17

def divide(dividend, divisor)
  remainder = dividend
  quotient = 0

  if divisor <= 0
    puts "Divisor must be a non-zero positive integer"
    exit
  end

  if dividend >= 0
    while remainder >= divisor
      remainder = remainder - divisor
      quotient = quotient + 1
    end
  else
    while remainder < 0
      remainder = remainder + divisor
      quotient = quotient - 1
    end
  end
  [quotient, remainder]
end

if __FILE__ == $0
  dividend = 45
  divisor = 11
  quotient, remainder = divide(dividend, divisor)
  puts "#{'%3d' % dividend} = #{'%2d' % quotient}*#{divisor} + #{remainder}"

  dividend = -45
  divisor = 11
  quotient, remainder = divide(dividend, divisor)
  puts "#{'%3d' % dividend} = #{'%2d' % quotient}*#{divisor} + #{remainder}"
end
