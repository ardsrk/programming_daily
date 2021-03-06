# Birthday paradox tells that in a room with 23 people there is about 50% chance that any two of them
# have the same birthday. 
#
# This program demonstrates birthday paradox by generating random hex strings for 32 bits in length.
# 
# Input:
#   BITS: Length of random hex string generated by SecureRandom
#
# Output:
#   n: number of attempts needed for hash collision.
#   p32(n): Probability of collision given n attempts for 32 bit long string.
#
# Example:
#   If random hexadecimal strings (32-bits in length) are used as session IDs for visitors of a web application
#   then there is a 50% probablity that two users among 65536 (square-root of 2**32) users share the
#   same session ID leading to under-counting of unique visitors.
#
# References:
#   https://www.youtube.com/watch?v=ofTb57aZHZs
#   https://brilliant.org/wiki/birthday-paradox/#application-to-cryptography

require 'securerandom'

BITS = 32

def generate_random_hex_strings
  h = {}
  n = 0
  loop do
    r = SecureRandom.hex(BITS/8)
    n = n + 1
    if h[r]
      puts "n     : #{n}"
      break
    else
      h[r] = 1
    end
  end
  n
end

def collision_probability(n, bits=BITS)
  m = 2**bits
  nsquared = n*n
  probability = Rational(nsquared, 2*m).to_f.round(2)
  puts "p32(n): #{probability}"
end

n = generate_random_hex_strings
collision_probability(n)
