def num_to_s(number, base)
	num_str = ''
	pow = 0
	numbers = %W(0 1 2 3 4 5 6 7 8 9 A B C D E F)

	until (number / (base ** pow)) == 0 do
		num_str << numbers[((number / (base ** pow)) % base)]
		pow += 1
	end
	num_str.reverse
end

def caesar(str, shift)
	chars = str.split('')
	chars.map do |c| 
		c == ' ' ? ' ' : ((c.ord - 97 + shift) % 26 + 97).chr
	end.join
end



# p num_to_s(234, 10) #=> "234"
# p num_to_s(234, 2)  #=> "11101010"
# p num_to_s(234, 16) #=> "EA"

# p caesar("helloz", 3) # => "khoor"