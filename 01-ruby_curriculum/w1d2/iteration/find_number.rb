# Write a loop the finds the first number that is (a) >250 and (b) divisible by 7

def find_number
  i = 1
  until i > 250 do 
    i *= 7
  end
  i
end

p find_number