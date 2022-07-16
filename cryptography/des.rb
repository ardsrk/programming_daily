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

  # 64-bit key in hex
  def key
    "133457799BBCDFF1"
  end

  # 64-bit key as binary string
  def binary_key
    ("%64s" % key.to_i(16).to_s(2)).gsub(" ", "0")
  end

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
end

def pretty_print(binary_string, sep)
  result = binary_string.dup
  result.scan(/\d{#{sep}}/).join(" ")
end

d = DES.new

puts "         64-bit KEY: #{d.key}"
puts

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
