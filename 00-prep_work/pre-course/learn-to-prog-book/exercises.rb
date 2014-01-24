# 2.5 A Few Things to Try
# Write a program that tells you the following:
# • Hours in a year. How many hours are in a year?
# • Minutes in a decade. How many minutes are in a decade?
# • Your age in seconds. How many seconds old are you? (I’m not going 
# to check your answer, so be as accurate—or not—as you want.)
# Here’s a tougher question:
# • Our dear author’s age. If I am 1,025 million seconds old (which I am, 
# though I was in the 800 millions when I started this book), how old am I?

hours_in_year = 365 * 24
minutes_in_decade = hours_in_year * 60 * 10
my_years_in_seconds = 29 * hours_in_year * 60 * 60
author_years = 1025000000 / 60 / 60 / 24 / 365
p author_years


# 5.6 A Few Things to Try
# • Full name greeting. Write a program that asks for a person’s first name, 
# then middle, and then last. Finally, it should greet the person using their full name.
# • Bigger, better favorite number. Write a program that asks for a person’s favorite 
# number. Have your program add 1 to the number, and then suggest the result as a bigger 
# and better favorite number. (Do be tactful about it, though.)

def greet
  puts "First name please!"
  first = gets.chomp
  puts "Now middle!"
  middle = gets.chomp
  puts "Last, your last!"
  last = gets.chomp
  puts "Greetings, #{first} #{middle} #{last}!"
end

def better_number
  puts "What is your favorite number?"
  num = gets.chomp.to_i
  puts "What a dumb number! #{num+1} is much cooler!"
end


# 6.2 A Few Things to Try
# • Angry boss. Write an angry boss program that rudely asks what you want. 
# Whatever you answer, the angry boss should yell it back to you and then 
# fire you. For example, if you type in I want a raise, it should yell back 
# like this:
# WHADDAYA MEAN "I WANT A RAISE"?!? YOU'RE FIRED!!
# • Table of contents. Here’s something for you to do in order to play around 
# more with center, ljust, and rjust: write a program that will display a 
# table of contents.

def angry_boss
  puts "WHAT DO YOU WANT?! THIS BETTER BE GOOD!"
  ask = gets.chomp
  puts %Q(WHADDAYA MEAN "#{ask.upcase}"?!? YOU'RE FIRED!!)
end

def toc(contents)
  # contents should be an array of 2-element arrays
  # eg [["Getting Started", 1], ["Numbers", 9], ["Letters", 13]]
  line_width = 60
  puts "Table of Contents\n".center(line_width)
  contents.each_with_index do |chapter, dex|
    puts "Chapter #{dex+1}:  #{chapter[0]}".ljust(line_width/2) + "Page ".rjust((line_width/2) - 2) + "#{chapter[1]}".rjust(2)
  end
end

toc([["Getting Started", 1], ["Numbers", 9], ["Letters", 13]])



# 7.5 A Few Things to Try
# • “99 Bottles of Beer on the Wall.” Write a program that prints out the 
# lyrics to that beloved classic, “99 Bottles of Beer on the Wall.”
# • Deaf grandma. Whatever you say to Grandma (whatever you type in), she 
# should respond with this:
     # HUH?!  SPEAK UP, SONNY!
# unless you shout it (type in all capitals). If you shout, she can hear you 
  # (or at least she thinks so) and yells back:
     # NO, NOT SINCE 1938!
# To make your program really believable, have Grandma shout a different year 
# each time, maybe any year at random between 1930 and 1950. (This part is optional 
# and would be much easier if you read the section on Ruby’s random number 
# generator on page 38.) You can’t stop talking to Grandma until you shout BYE.
# Hint 1: Don’t forget about chomp! 'BYE' with an Enter at the end is not the same 
# as 'BYE' without one!
# Hint 2: Try to think about what parts of your program should happen over and over 
# again. All of those should be in your while loop.
# Hint 3: People often ask me, “How can I make rand give me a number in a range not 
# starting at zero?” Well, you can’t; rand just doesn’t work that way. So, I guess 
# you’ll have to do something to the number rand returns to you.
# 
# • Deaf grandma extended. What if Grandma doesn’t want you to leave? When you shout 
# BYE, she could pretend not to hear you. Change your previous program so that you 
# have to shout BYE three times in a row. Make sure to test your program: if you shout 
# BYE three times but not in a row, you should still be talking to Grandma.
# • Leap years. Write a program that asks for a starting year and an ending year and 
# then puts all the leap years between them (and including them, if they are also leap 
# years). Leap years are years divisible by 4 (like 1984 and 2004). However, years 
# divisible by 100 are not leap years (such as 1800 and 1900) unless they are also 
# divisible by 400 (such as 1600 and 2000, which were in fact leap years). What a mess!

bottles_99 = Enumerator.new do |enum|
  bottles = 99
  until bottles <= 0
    enum.yield %Q(
    #{bottles} bottles of beer on the wall,
    #{bottles} bottles of beeeer!
    Take one down, pass it around,
    #{bottles-1} bottles of beer on the wall!)
    
    bottles -= 1
  end
  yield "No more beer! Go home, you're drunk!"
end

puts bottles_99.next
puts bottles_99.next # loop for full song
puts

def deaf_gma
  puts "OH HELLO THERE!"
  byes = 0
  last = "BYE"
  re = gets.chomp
  loop do       
    byes += 1 if (re == "BYE" && last == "BYE")
    break if byes >= 3
    re == re.upcase ? puts("NO, NOT SINCE #{rand(1930..1950)}!") : puts("HUH?!  SPEAK UP, SONNY!")
    last = re
    re = gets.chomp
  end
  puts "OH FINE, GOODBYE ALREADY!"
end

def leap_years(start, finish)
  (start..finish).select { |year| ((year % 4 == 0 && year % 100 != 0) ||
                                   (year % 100 == 0 && year % 400 == 0)) }
end

p leap_years(1750, 1850)



# 8.3 A Few Things to Try
# • Building and sorting an array. Write the program we talked about 
# at the beginning of this chapter, one that asks us to type as many
# words as we want (one word per line, continuing until we just press 
# Enter on an empty line) and then repeats the words back to us in 
# alphabetical order. Make sure to test your program thoroughly; for 
# example, does hitting Enter on an empty line always exit your program? 
# Even on the first line? And the second? Hint: There’s a lovely array 
# method that will give you a sorted version of an array: sort. Use it!
# • Table of contents, revisited. Rewrite your table of contents program 
# on page 36. Start the program with an array holding all of the information 
# for your table of contents (chapter names, page numbers, and so on). 
# Then print out the information from the array in a beautifully formatted 
# table of contents.  ***ALREADY DID THAT

def array_sort_playback
  # written for strings to return in alphabetical order 
  arr = []
  loop do
    puts "Please type the next element of the array"
    re = gets.chomp
    break if re == ''
    arr << re
  end
  puts arr.sort
end

def toc(contents)
  # contents should be an array of 2-element arrays
  # eg [["Getting Started", 1], ["Numbers", 9], ["Letters", 13]]
  line_width = 60
  puts "Table of Contents\n".center(line_width)
  contents.each_with_index do |chapter, dex|
    puts "Chapter #{dex+1}:  #{chapter[0]}".ljust(line_width/2) + "Page ".rjust((line_width/2) - 2) + "#{chapter[1]}".rjust(2)
  end
end


# 9.5 A Few Things to Try
# • Improved ask method. That ask method I showed you was OK, but I 
# bet you could do better. Try to clean it up by removing the answer 
# variable. You’ll have to use return to exit from the loop. (Well, 
# it will get you out of the whole method, but it will get you out 
# of the loop in the process.) How do you like the resulting method? 
# I usually try to avoid using return (a personal preference), but 
# I might make an exception here.
# • Old-school Roman numerals. In the early days of Roman numerals, 
# the Romans didn’t bother with any of this new-fangled subtraction 
# “IX” nonsense. No sir, it was straight addition, biggest to littlest
# so 9 was written “VIIII,” and so on. Write a method that when passed 
# an integer between 1 and 3000 (or so) returns a string containing the 
# proper old-school Roman numeral. In other words, old_roman_numeral 4 
# should return 'IIII'. Make sure to test your method on a bunch of 
# different numbers. Hint: Use the inte- ger division and modulus 
# methods on page 37.
# For reference, these are the values of the letters used:
# I =1 V=5 X=10 L=50 C=100 D=500 M=1000
# • “Modern” Roman numerals. Eventually, someone thought it would be 
# terribly clever if putting a smaller number before a larger one meant 
# you had to subtract the smaller one. As a result of this development, 
# you must now suffer. Rewrite your previous method to return the new-style 
# Roman numerals so when someone calls roman_numeral 4, it should return 'IV'.



def ask(question)
  loop do
    puts question
    reply = gets.chomp.downcase
    if (reply == 'yes' || reply == 'no')
      return reply == 'yes'
    else
      puts 'Please answer "yes" or "no".' 
    end
  end
end


def old_numerals(num)
  numerals = [[1000, "M"], [500, "D"], [100, "C"], [50, "L"], [10, "X"], [5, "V"], [1, "I"]]
  ans = ''
  numerals.each do |val, sym|
    (num/val).times { |i| ans += sym }
    num %= val
  end
  ans
end

p old_numerals(1414)

def numerals(num)
  edits = {"IIII" => "IV", "XXXX" => "XL", "CCCC" => "CD"}
  old_skool = old_numerals(num)
  edits.each do |key, val|
    old_skool.gsub!(key, val)
  end
  old_skool
end

p numerals(1414)
p numerals(14)



# 10.3 A Few Things to Try
# • Shuffle. Write a shuffle method that takes an 
# array and returns a totally shuffled version. As always, you’ll 
# want to test it, but testing this one is trickier: How can you 
# test to make sure you are getting a perfect shuffle? What would 
# you even say a perfect shuffle would be? Now test for it.
# • Dictionary sort. Your sorting algorithm is pretty good, sure. 
# But there was always that sort of embarrassing point you were 
# hoping I’d just sort of gloss over, right? About the capital 
# letters? Your sorting algorithm is good for general-purpose 
# sorting, but when you sort strings, you are using the ordering 
# of the characters in your fonts (called the ASCII codes) rather 
# than true dictionary ordering. In a dictionary, case (upper or 
# lower) is irrelevant to the ordering. So, make a new method to 
# sort words (something like dictionary_sort). Remember, though, 
# that if I give your program words starting with capital letters, 
# it should return words with those same capital letters, just 
# ordered as you’d find in a dictionary.

def shuffle_up(arr)
  # alternately just call .shuffle...
  shuffled = []
  until arr.empty? do
    shuffled << arr.delete_at(rand(arr.length))
  end
  shuffled
end

p shuffle_up([1, 2, 3, 4, 5, 6, 7, 8])

def sort_nocase(arr)
  arr.sort! { |i, j| i.downcase <=> j.downcase }
end

p sort_nocase(%w(hi Hey check This OUT man aBsolutely Amazing))



# 10.5 A Few More Things to Try
# • Expanded english_number. First, put in thousands; it should 
# return 'one thousand' instead of (the sad) 'ten hundred' and 'ten 
# thousand' instead of 'one hundred hundred'.
# Now expand upon english_number some more. For example, put in 
# millions so you get 'one million' instead of 'one thousand 
# thousand'. Then try adding billions, trillions, and so on.
# • “Ninety-nine Bottles of Beer on the Wall.” Using english_number 
# and your old program on page 57, write out the lyrics to this song 
# the right way this time. Punish your computer: have it start at 9999. 
# (Don’t pick a number too large, though, because writing all of that 
# to the screen takes your computer quite a while. A hundred thousand 
# bottles of beer takes some time; and if you pick a million, you’ll 
# be punishing yourself as well!)


# realistically...
require 'numbers_and_words'

def english_number(n)
  n.to_words
end

p english_number(39057023750237502586359267895)

bottles_99_words = Enumerator.new do |enum|
  bottles = 99
  until bottles <= 0
    enum.yield %Q(
    #{bottles.to_words.capitalize} bottles of beer on the wall,
    #{bottles.to_words} bottles of beeeer!
    Take one down, pass it around,
    #{(bottles-1).to_words} bottles of beer on the wall!)
    
    bottles -= 1
  end
  yield "No more beer! Go home, you're drunk!"
end

puts bottles_99_words.next

