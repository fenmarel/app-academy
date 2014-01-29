def super_print(str, options = {})
  modified = str.dup
  repeat = options[:times] ? options[:times] : 1
  
  modified.upcase! if options[:upcase]
  modified.reverse! if options[:reverse]
  
  puts modified * repeat
end

super_print("Hello")                                    #=> "Hello"
super_print("Hello", :times => 3)                       #=> "Hello" 3x
super_print("Hello", :upcase => true)                   #=> "HELLO"
super_print("Hello", :upcase => true, :reverse => true) #=> "OLLEH"
