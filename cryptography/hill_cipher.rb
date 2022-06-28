require_relative "./crypto_matrix"

# Hill Cipher
#
# Problem:
#   Give a plain text, demonstrate encryption and decryption of the message using Hill Cipher. 
#
# Input: ( for encryption )
#   KEY: 3x3 matrix
#   ALPHABETS: a to z
#   M: 27 (number of alphabets)
#   BLOCK_SIZE: 3 (equal to dimension of KEY matrix)
#
# Input: ( for decryption )
#   KEY_INVERSE: Inverse of KEY under modulo M
#   ALPHABETS: a to z
#   M: 27 (number of alphabets)
#   BLOCK_SIZE: 3 (equal to dimension of KEY matrix)
#
# Output:
#   Cipher-text for encrypt method and plain-text for decrypt method
#
# References:
#   https://www.youtube.com/watch?v=sh7x6ReqLRI

ALPHABETS = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" , " "]

M = 27

KEY = CryptoMatrix.new([
  [10, 5, 12],
  [3, 14, 21],
  [8, 9, 11]
])

KEY_INVERSE = KEY.inverse(M)

BLOCK_SIZE = KEY.rows

def string_to_array(string)
  string.downcase.split(//).collect do |i|
    ALPHABETS.index(i)
  end
end

def array_to_string(array)
  array.collect do |i|
    ALPHABETS.at(i)
  end.join
end

def encrypt(message)
  result = string_to_array(message).each_slice(BLOCK_SIZE).collect do |slice|
    KEY.multiply(slice, M)
  end
  result.collect do |array|
    array_to_string(array)
  end.join
end

def decrypt(message)
  result = string_to_array(message).each_slice(BLOCK_SIZE).collect do |slice|
    KEY_INVERSE.multiply(slice, M)
  end
  result.collect do |array|
    array_to_string(array)
  end.join
end

def massage(message)
  if message.size % BLOCK_SIZE != 0
    padding = BLOCK_SIZE - (message.size % BLOCK_SIZE)
    message + " " * padding
  else
    message
  end
end

message = 'she sells sea shells by the sea shore'
puts "Message       : #{message}"
cipher_text = encrypt(massage(message))
puts "Ciphertext    : #{cipher_text}"
decrypted_text = decrypt(cipher_text)
puts "Decrypted Text: #{decrypted_text}"
puts "Key: \n#{KEY}"
