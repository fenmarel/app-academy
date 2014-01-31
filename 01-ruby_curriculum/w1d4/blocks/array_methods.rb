class Array
  def my_each(&prc)
    dup_arr = self.dup
    until dup_arr.empty?
      prc.call(dup_arr.shift)
    end

    self
  end

  def my_map(&prc)
    new_arr = []
    self.my_each {|num| new_arr << prc.call(num)}
    new_arr
  end

  def my_select(&prc)
    new_arr = []
    self.my_each {|num| new_arr << num if prc.call(num)}
    new_arr
  end

  def my_inject(&prc)
    new_arr = self.dup
    sum = new_arr.shift
    new_arr.my_each {|num| sum = prc.call(sum, num) }
    sum
  end

  def my_sort(&prc)
    new_arr = self.dup

    def qs_helper(array, &prc)
      return array if array.length <= 1

      pivot = array.length / 2
      left = array.select {|num| prc.call(num, array[pivot]) == -1 }
      right = array.select {|num| prc.call(num, array[pivot]) == 1 }

      qs_helper(left) + [array[pivot]] + qs_helper(right)
    end

    qs_helper(self, &prc)
  end
end


# [1, 2, 3].my_each {|num| puts num * 2}
# p [1, 2, 3].my_map {|num| num + 1}
# p [1, 2, 3].my_select {|num| num == 1}
# p [1, 2, 3].my_inject {|sum, num| sum + num}
# p [1, 3, 5].my_sort { |num1, num2| num2 <=> num1 }