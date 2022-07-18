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

  def to_hex(msb)
    ("%#{msb}s" % self.to_s(16)).gsub(" ", "0")
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

  # IP_INV: Used to permute 64-bit cipher-text obtained after 16 rounds
  # of applying 16 sub-keys to plain-text
  IP_INV = [
    [40, 8, 48, 16, 56, 24, 64, 32],
    [39, 7, 47, 15, 55, 23, 63, 31],
    [38, 6, 46, 14, 54, 22, 62, 30],
    [37, 5, 45, 13, 53, 21, 61, 29],
    [36, 4, 44, 12, 52, 20, 60, 28],
    [35, 3, 43, 11, 51, 19, 59, 27],
    [34, 2, 42, 10, 50, 18, 58, 26],
    [33, 1, 41,  9, 49, 17, 57, 25],
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

  # Used by expansion function to expand 32-bit right cipher text to 48-bits
  E = [
    [32,  1,  2,  3,  4,  5],
    [ 4,  5,  6,  7,  8,  9],
    [ 8,  9, 10, 11, 12, 13],
    [12, 13, 14, 15, 16, 17],
    [16, 17, 18, 19, 20, 21],
    [20, 21, 22, 23, 24, 25],
    [24, 25, 26, 27, 28, 29],
    [28, 29, 30, 31, 32,  1],
  ]

  # Used in the final step of f-function
  P = [
    [16,  7, 20, 21],
    [29, 12, 28, 17],
    [ 1, 15, 23, 26],
    [ 5, 18, 31, 10],
    [ 2,  8, 24, 14],
    [32, 27,  3,  9],
    [19, 13, 30,  6],
    [22, 11,  4, 25],
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

  def l0
    @l0 ||= ip.to_bin(DES::BLOCK_SIZE)[0..31].to_i(2)
  end

  def r0
    @r0 ||= ip.to_bin(DES::BLOCK_SIZE)[32..-1].to_i(2)
  end

  # the expansion function
  def e(r)
    r_bin = r.to_bin(DES::BLOCK_SIZE/2)
    E.collect do |row|
      row.collect do |idx|
        r_bin[idx-1]
      end
    end.flatten.join.to_i(2)
  end

  # the f function of DES
  def f(r, k)
    xored = e(r) ^ k
    xored_bin = xored.to_bin(DES::SUB_KEY_SIZE)
    bin_array = xored_bin.scan(/\d{6}/)
    result = 1.upto(8).collect do |i|
      send("s#{i}", bin_array[i-1])
    end.join
    P.collect do |row|
      row.collect do |idx|
        result[idx-1]
      end
    end.join.to_i(2)
  end

  1.upto(8) do |i|
    define_method("s#{i}") do |b|
      r_idx = "#{b[0]}#{b[-1]}".to_i(2)
      c_idx = "#{b[1]}#{b[2]}#{b[3]}#{b[4]}".to_i(2)
      val = self.class.const_get("S#{i}")[r_idx][c_idx]
      val.to_bin(4)
    end
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

    # define methods to generate 16 32-bit left and right cipher texts
    define_method("l#{i}") do
      result = instance_variable_get("@l#{i}")
      if result
        result
      else
        instance_variable_set("@l#{i}", send("r#{i-1}"))
      end
    end

    define_method("r#{i}") do
      result = instance_variable_get("@r#{i}")
      if result
        result
      else
        instance_variable_set("@r#{i}", send("l#{i-1}") ^ f(send("r#{i-1}"), send("k#{i}")))
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

  def ip_inv
    return @ip_inv if @ip_inv
    rl_bin = @rl_16.to_bin(BLOCK_SIZE)
    @ip = IP_INV.collect do |row|
      row.collect do |idx|
        rl_bin[idx-1]
      end
    end.flatten.join.to_i(2)
  end

  # m: 64-bit message
  def encrypt(m)
    @msg = m
    ip
    @rl_16 = (send("r16").to_bin(DES::BLOCK_SIZE/2) + send("l16").to_bin(DES::BLOCK_SIZE/2)).to_i(2)
    ip_inv.to_s(16)
  end

  def decrypt(cipher)
    bin_cipher = cipher.to_i(16).to_bin(BLOCK_SIZE)
    cipher_ip = IP.collect do |row|
      row.collect do |idx|
        bin_cipher[idx-1]
      end
    end.flatten.join.to_i(2)

    cl0 = (cipher_ip.to_bin(DES::BLOCK_SIZE)[0..31]).to_i(2)
    cr0 = (cipher_ip.to_bin(DES::BLOCK_SIZE)[32..-1]).to_i(2)

    cl_array = [cl0]
    cr_array = [cr0]

    idx = 1
    16.downto(1) do |i|
      cl_array << cr_array[idx-1]
      cr_array << (cl_array[idx-1] ^ f(cr_array[idx-1], send("k#{i}")))
      idx = idx + 1
    end
    crl_16 = (cr_array.last.to_bin(DES::BLOCK_SIZE/2) + cl_array.last.to_bin(DES::BLOCK_SIZE/2)).to_i(2)

    crl_bin = crl_16.to_bin(BLOCK_SIZE)
    plain_text = IP_INV.collect do |row|
      row.collect do |idx|
        crl_bin[idx-1]
      end
    end.flatten.join.to_i(2)

    plain_text.to_hex(DES::BLOCK_SIZE/4)
  end
end

def pretty_print(binary_string, sep)
  result = binary_string.dup
  result.scan(/\d{#{sep}}/).join(" ")
end

d = DES.new

puts "       KEY: #{d.key}"

# 64-bit message
m = "0123456789ABCDEF"

puts " PlainText: #{m}"
cipher_text = d.encrypt(m).upcase
puts "CipherText: #{cipher_text}"
decrypted = d.decrypt(cipher_text).upcase
puts "  Decryped: #{decrypted}"
