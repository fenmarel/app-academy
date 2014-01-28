class Integer

  def in_words
    return "zero" if self == 0
    left = self
    words = []

    nums = [['trillion', 1000000000000], 
            ['billion',  1000000000], 
            ['million',  1000000],
            ['thousand', 1000], 
            ['hundred',  100]]

    nums.each do |word, num|
      words << (left / num).add_words(word) if (left / num) > 0
      left %= num
    end

    words << left.under_hundred
    words.join(' ').strip
  end

  def under_hundred
    ones = [nil, "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    teens = %W(ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen)
    tens = %W(zero ten twenty thirty forty fifty sixty seventy eighty ninety)

    if self < 10
      ones[self]
    elsif self < 20
      teens[self % 10]
    elsif self % 10 == 0
      tens[self / 10]
    else
      "#{tens[self / 10]} #{(self % 10).in_words}"
    end
  end

  def add_words(word)
    self.in_words + " #{word}"
  end
end
