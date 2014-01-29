#!/usr/bin/env ruby

def rpn(input = nil)
  equation = nil
  
  if is_filename?(input)
    File.open(input).each_line do |line|
      equation = line.chomp.split
    end
  elsif not input.nil?
    # Treat input as a string equation
    equation = input.split
  else
    puts "No equation given, please enter an equation."
    equation = gets.chomp.split
  end
  
  stack = []
  equation.each do |element|
    calculate!(element, stack)
  end
  stack[0]
end

def calculate!(element, stack = [])  
  if %W(+ - / *).include?(element)
    operator = element.to_sym
    var1 = stack.pop
    var2 = stack.pop
    stack << var2.send(operator, var1)
  else
    stack << element.to_i
  end
end

def is_filename?(name)
  !!(name =~ /.*\.txt/i)
end


if $PROGRAM_NAME == __FILE__
  file = ARGV[0]
  puts rpn(file)
end
