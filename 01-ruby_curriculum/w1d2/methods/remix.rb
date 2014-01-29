class Array
  def unzip
    [[], []].tap do |unzipped|
      self.each do |a, b|
        unzipped[0] << a
        unzipped[1] << b
      end
    end
  end
  
  def complete_shuffle
    shuffled = []
    fully_shuffled = false
  
    until fully_shuffled
      shuffled = self.shuffle
      fully_shuffled = true
    
      shuffled.each_index do |i|
        fully_shuffled = false if shuffled[i] == self[i]
      end
    end
    shuffled
  end
end


def remix(ingredients)
  alcohols, mixes = ingredients.unzip
  shuffled_mixes = mixes.complete_shuffle

  alcohols.zip(shuffled_mixes)
end




# p remix([
#   ["rum", "coke"],
#   ["gin", "tonic"],
#   ["scotch", "soda"]
# ])