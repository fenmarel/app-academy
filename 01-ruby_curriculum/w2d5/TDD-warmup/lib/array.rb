class Array
  def my_uniq
    self.uniq
  end

  def two_sum
    [].tap do |sums|
      self.each_with_index do |val, i|
        self.each_with_index do |val2, j|
          next if j <= i
          sums << [i, j] if (val + val2 == 0)
        end
      end
    end
  end

  def my_transpose
    return [] if self.empty?

    unless self.first.is_a?(Array)
      raise TypeError.new("can't convert Fixnum into Array")
    end

    new_arr = Array.new(self[0].length) { Array.new(self.length) }

    self[0].each_index do |i|
      self.each_index do |j|
        new_arr[i][j] = self[j][i]
      end
    end

    new_arr
  end
end