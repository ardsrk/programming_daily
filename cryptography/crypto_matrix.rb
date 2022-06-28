require_relative './euclid_extended_gcd'

# Class named Matrix is part of Ruby standard library
# Purpose of this class is to compute inverse of a matrix under mod m. See CryptoMatrix#inverse_modm
class CryptoMatrix

  include Enumerable

  def initialize(rows)
    @row_vectors = rows
  end

  def columns
    @row_vectors.first.count
  end

  def multiply_by_vector(v)
    if columns != v.count
      raise "multiplication not possible"
    end

    array = rows.times.collect do |i|
      v.count.times.collect do |j|
        at(i,j) * v.at(j)
      end.sum
    end
    array
  end

  def *(am)
    if Array === am
      return multiply_by_vector(am)
    end

    if columns != am.rows
      raise "multiplication not possible"
    end

    self.class.new(rows.times.collect do |i|
      am.columns.times.collect do |j|
        am.columns.times.collect do |k|
          at(i,k) * am.at(k,j)
        end.sum
      end
    end)
  end

  def multiply(am, m=nil)
    result = self * am
    if m.nil?
      result
    elsif Array === result
      new_rows = result.collect do |num|
        num % m
      end
    else
      new_rows = result.collect do |r|
        r.collect do |num|
          num % m
        end
      end
      self.class.new(new_rows)
    end
  end

  def each(&block)
    if block_given?
      @row_vectors.each { |el| yield(el) }
    else
      @row_vectors.each
    end
  end

  def append(m)
    if rows != m.rows
      raise "Append not possible"
    end
    rows = collect.with_index do |r, i|
      r = r + m.at(i)
    end
    self.class.new(rows)
  end

  def identity
    rows = collect.with_index do |r, i|
      r.collect.with_index do |_, j|
        if i == j
          1
        else
          0
        end
      end
    end
    self.class.new(rows)
  end

  def rows
    @row_vectors.count
  end

  def dup
    rows = @row_vectors.collect {|v| v.dup}
    CryptoMatrix.new(rows)
  end

  def at(i, j=nil)
    if j.nil?
      @row_vectors[i]
    else
      @row_vectors[i].at(j)
    end
  end

  def to_s
    collect do |r|
      "[#{r.join(", ")}]"
    end.join("\n")
  end

  def remove_denominators!
    0.upto(@row_vectors.count - 1) do |i|
      @row_vectors[i].collect!.with_index do |el, i|
        case el.class.name
        when "Rational"
          (el.denominator == 1) ? el.numerator : el
        else
          el
        end
      end
    end
  end

  def row_reduce
    a = self.dup
    r = -1 
    a.columns.times do |j|
      i = r + 1
      while i < a.rows and a.at(i,j) == 0
        i = i + 1
      end
      if i < a.rows
        r = r + 1
        a.swap!(i, r) if i != r
        a.scale!(r, j)
        0.upto(a.rows-1) do |k|
          if k != r
            a.reduce!(k, j, r)
          end
        end
      end
    end
    a.remove_denominators!
    return r, a
  end

  # inverse mod m
  def inverse(m = nil)
    ai = append(identity)
    r, rai = ai.row_reduce
    if r != rows - 1
      raise "Inverse does not exist"
    end
    result = rai.extract_from_column(rows)
    if m.nil?
      return result
    end
    inverse_modm = result.collect do |r|
      r.collect do |num|
        if Rational === num
          gcd, x, y = xgcd(num.denominator, m)
          if gcd != 1
            raise "Inverse does not exist"
          end
          (num.numerator * x) % m
        else
          num
        end
      end
    end
    self.class.new(inverse_modm)
  end

  def extract_from_column(index)
    extracted_rows = collect do |r|
      r[index..-1]
    end
    self.class.new(extracted_rows)
  end

  def swap!(i, j)
    puts "swap row #{i} and #{j}" if $DEBUG
    tmp = @row_vectors[i]
    @row_vectors[i] = @row_vectors[j]
    @row_vectors[j] = tmp
    puts "#{self}" if $DEBUG
  end

  def scale!(r, j)
    val = at(r, j)
    puts "Divide row #{r} by #{val} @(#{r},#{j}); " if $DEBUG
    @row_vectors[r].collect! do |el|
      Rational(el, val)
    end
    puts "#{self}" if $DEBUG
  end

  def reduce!(k, j, r)
    val = -at(k, j)
    scaled_r = @row_vectors[r].collect do |el|
      val * el
    end

    puts "reduce row #{k} by #{val} * #{@row_vectors[r]}. r = #{r}" if $DEBUG
    @row_vectors[k].collect!.with_index do |el, i|
      rat = Rational(scaled_r[i] + el)
    end
    puts "#{self}" if $DEBUG
  end
end

if __FILE__ == $0
  a = CryptoMatrix.new [
    [1, 2],
    [-1,0]
  ]
  puts "a = \n#{a}"
  puts 
  puts "ainv mod 29 =\n#{a.inverse(29)}"
  puts 
  puts "a * ainv (mod 29) =\n#{a.multiply(a.inverse(29), 29)}"
end
