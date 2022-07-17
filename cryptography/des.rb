class Integer

  # msb: most significant bit
  def rotate_left(msb, count=1)
    temp = self
    mask = 2**(msb-1)
    count.times do
      msb_value = temp & mask
      temp = temp << 1
      temp = temp & ((2**msb)-1)
      if msb_value == mask
        temp = temp | 1
      end
    end
    return temp
  end

  def to_bin(msb)
    ("%#{msb}s" % self.to_s(2)).gsub(" ", "0")
  end
end

class DES

  attr_accessor :msg

  # 64-bit key in hex
  def key
    "133457799BBCDFF1"
  end

  # 64-bit key as binary string
  def binary_key
    ("%64s" % key.to_i(16).to_s(2)).gsub(" ", "0")
  end

  BLOCK_SIZE = 64

  KEY_SIZE = 56

  SUB_KEY_SIZE = 48

  # PC-1: Used to obtain permuted 56-bit key from the original 64-bit key
  PC_1 = [
    [57, 49, 41, 33, 25, 17,  9],
    [ 1, 58, 50, 42, 34, 26, 18],
    [10,  2, 59, 51, 43, 35, 27],
    [19, 11,  3, 60, 52, 44, 36],
    [63, 55, 47, 39, 31, 23, 15],
    [ 7, 62, 54, 46, 38, 30, 22],
    [14,  6, 61, 53, 45, 37, 29],
    [21, 13,  5, 28, 20, 12,  4],
  ]

  # PC-2: Used to obtain K1 to K16 sub-keys of 48-bits each
  PC_2 = [
    [14, 17, 11, 24,  1,  5],
    [ 3, 28, 15,  6, 21, 10],
    [23, 19, 12,  4, 26,  8],
    [16,  7, 27, 20, 13,  2],
    [41, 52, 31, 37, 47, 55],
    [30, 40, 51, 45, 33, 48],
    [44, 49, 39, 56, 34, 53],
    [46, 42, 50, 36, 29, 32],
  ]

  # IP: Used to permute 64-bit message blocks
  IP = [
    [58, 50, 42, 34, 26, 18, 10, 2],
    [60, 52, 44, 36, 28, 20, 12, 4],
    [62, 54, 46, 38, 30, 22, 14, 6],
    [64, 56, 48, 40, 32, 24, 16, 8],
    [57, 49, 41, 33, 25, 17,  9, 1],
    [59, 51, 43, 35, 27, 19, 11, 3],
    [61, 53, 45, 37, 29, 21, 13, 5],
    [63, 55, 47, 39, 31, 23, 15, 7],
  ]

  # S1-S8: S-boxes used in f function
  S1 = [
    [14,  4, 13, 1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9, 0,  7],
    [ 0, 15,  7, 4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5, 3,  8],
    [ 4,  1, 14, 8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10, 5,  0],
    [15, 12,  8, 2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0, 6, 13],
  ]

  S2 = [
    [15,  1,  8, 14,  6, 11,  3,  4,  9, 7,  2, 13, 12, 0,  5, 10],
    [ 3, 13,  4,  7, 15,  2,  8, 14, 12, 0,  1, 10,  6, 9, 11,  5],
    [ 0, 14,  7, 11, 10,  4, 13,  1,  5, 8, 12,  6,  9, 3,  2, 15],
    [13,  8, 10,  1,  3, 15,  4,  2, 11, 6,  7, 12,  0, 5, 14,  9],
  ]

  S3 = [
    [10,  0,  9, 14, 6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8],
    [13,  7,  0,  9, 3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1],
    [13,  6,  4,  9, 8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7],
    [ 1, 10, 13,  0, 6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12],
  ]

  S4 = [
    [ 7, 13, 14, 3,  0,  6,  9, 10,  1, 2, 8,  5, 11, 12,  4, 15],
    [13,  8, 11, 5,  6, 15,  0,  3,  4, 7, 2, 12,  1, 10, 14,  9],
    [10,  6,  9, 0, 12, 11,  7, 13, 15, 1, 3, 14,  5,  2,  8,  4],
    [ 3, 15,  0, 6, 10,  1, 13,  8,  9, 4, 5, 11, 12,  7,  2, 14],
  ]

  S5 = [
    [ 2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13, 0, 14,  9],
    [14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3, 9,  8,  6],
    [ 4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6, 3,  0, 14],
    [11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10, 4,  5,  3],
  ]

  S6 = [
    [12,  1, 10, 15, 9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11],
    [10, 15,  4,  2, 7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8],
    [ 9, 14, 15,  5, 2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6],
    [ 4,  3,  2, 12, 9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13],
  ]

  S7 = [
    [ 4, 11,  2, 14, 15, 0,  8, 13,  3, 12, 9,  7,  5, 10, 6,  1],
    [13,  0, 11,  7,  4, 9,  1, 10, 14,  3, 5, 12,  2, 15, 8,  6],
    [ 1,  4, 11, 13, 12, 3,  7, 14, 10, 15, 6,  8,  0,  5, 9,  2],
    [ 6, 11, 13,  8,  1, 4, 10,  7,  9,  5, 0, 15, 14,  2, 3, 12],
  ]

  S8 = [
    [13,  2,  8, 4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7],
    [ 1, 15, 13, 8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2],
    [ 7, 11,  4, 1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8],
    [ 2,  1, 14, 7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11],
  ]

  # 56-bit key obtained by using PC_1 as lookup into BINARY_KEY
  def key_56
    PC_1.collect do |row|
      row.collect do |idx|
        binary_key[idx-1]
      end
    end.flatten.join
  end

  # Number of bits to left rotate to obtain the 16 48-bit sub-keys
  SHIFTS = [0, 1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1]

  def c0
    @c0 ||= key_56[0..27].to_i(2)
  end

  def d0
    @d0 ||= key_56[28..-1].to_i(2)
  end

  1.upto(16) do |i|
    # define methods to generate 28-bit keys from c1 to c16
    define_method("c#{i}") do 
      result = instance_variable_get("@c#{i}")
      if result
        result
      else
        result = send("c#{i-1}").rotate_left(KEY_SIZE/2, SHIFTS[i])
        instance_variable_set("@c#{i}", result)
      end
    end

    # define methods to generate 28-bit keys from d1 to d16
    define_method("d#{i}") do 
      result = instance_variable_get("@d#{i}")
      if result
        result
      else
        result = send("d#{i-1}").rotate_left(KEY_SIZE/2, SHIFTS[i])
        instance_variable_set("@d#{i}", result)
      end
    end

    # define methods to generate 48-bit keys from k1 to k16
    define_method("k#{i}") do
      result = instance_variable_get("@k#{i}")
      if result
        result
      else
        cd = send("c#{i}").to_bin(DES::KEY_SIZE/2) + send("d#{i}").to_bin(DES::KEY_SIZE/2)

        result = PC_2.collect do |row|
          row.collect do |idx|
            cd[idx-1]
          end
        end.flatten.join.to_i(2)
        instance_variable_set("@k#{i}", result)
      end
    end
  end

  def ip
    return @ip if @ip
    bin_msg = msg.to_i(16).to_bin(BLOCK_SIZE)
    @ip = IP.collect do |row|
      row.collect do |idx|
        bin_msg[idx-1]
      end
    end.flatten.join.to_i(2)
  end

  # m: 64-bit message
  def encrypt(m)
    @msg = m
    ip
  end
end

def pretty_print(binary_string, sep)
  result = binary_string.dup
  result.scan(/\d{#{sep}}/).join(" ")
end

d = DES.new

puts "         64-bit KEY: #{d.key}"
puts

# 64-bit message
m = "0123456789ABCDEF"

puts "56-bit permuted KEY: #{d.key_56.to_i(2).to_s(16).upcase}"
puts

0.upto(16) do |i|
  puts "#{'%3s: ' % ("c"+i.to_s) }" + d.send("c#{i}").to_bin(DES::KEY_SIZE/2)
  puts "#{'%3s: ' % ("d"+i.to_s) }" + d.send("d#{i}").to_bin(DES::KEY_SIZE/2)
  puts
end

1.upto(16) do |i|
  puts "#{'%3s: ' % ("k"+i.to_s)}" + pretty_print(d.send("k#{i}").to_bin(DES::SUB_KEY_SIZE), 6)
  puts
end

puts " M: #{pretty_print(m.to_i(16).to_bin(DES::BLOCK_SIZE), 4)}"
d.encrypt(m)
puts "IP: #{pretty_print(d.ip.to_bin(DES::BLOCK_SIZE), 4)}"
