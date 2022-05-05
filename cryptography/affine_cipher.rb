# Affine cipher
#
# Problem:
#   Given a string of plain-text encrypt it using
#   affine cipher and return the ciphertext
#
# Input:
#   1. Plain text
#   2. Private keys a, and b
#
# Output:
#   
#   e(x) = ax + b (mod m); where x is the plain-text and m is alphabet size
#
# References:
#   https://www.youtube.com/watch?v=l3JB7t4TBk0

ALPHABETS = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

def affine_cipher(x, a, b)
  x = x.downcase
  m = ALPHABETS.size
  x.size.times.collect do |i|
    ALPHABETS.at((ALPHABETS.index(x[i]) * a + b) % m)
  end.join
end

require_relative './euclid_extended_gcd'

def affine_decipher(e, a, b)
  e = e.downcase
  m = ALPHABETS.size
  _, ainv, _ = xgcd(a, m)
  e.size.times.collect do |i|
    ALPHABETS.at(((ALPHABETS.index(e[i]) - b ) * ainv) % m)
  end.join
end

# Note:
# 
# Encryption and Decryption using affine cipher only works if gcd(a, m) = 1. When a and m are mutually prime then
# a-inverse exists under (mod m)
#
# If gcd(a, m) > 1 then mapping between plain text and cipher text alphabets will not be unique
# To test this, set a=6 and run the program

x = "hot"
a = 7; b = 3
puts "Plaintext   : #{x}"
puts "Private keys: a=#{a}; b=#{b} "
puts "Ciphertext  : #{affine_cipher(x, a, b)}\n\n"

e = affine_cipher(x, a, b)
puts "Ciphertext  : #{e}"
puts "Private keys: a=#{a}; b=#{b} "
puts "Plaintext   : #{affine_decipher(e, a, b)}"
