# Linear Feedback Shift Register
#
# Problem:
#   Generate random numbers for use as keys in cryptographic algorithms
#
# Input:
#   m: Size of shift register ( in bits )
#   s: Random m bit number. Initial State
#   i: XOR the ith bit in register with shifted bit
#
# Output:
#   Series of random numbers till the shift register resets to s
#
# References:
#   https://www.youtube.com/watch?v=sKUhFpVxNWc
#   https://www.youtube.com/watch?v=Ks1pw1X22y4

m = 4
s = 9
i = 2

r = s
loop do 
  shifted_bit = (r & 1)
  ith_bit = ((r>>(i-1)) & 1)
  input_bit = shifted_bit ^ ith_bit
  r = (r >> 1)
  if (input_bit & 1 == 1)
    r = r | (2 ** (m-1))
  end
  puts "Random number: #{'%2s' % r} -> #{'%04d' % r.to_s(2)}"
  break if r == s
end
