def fib(n)
  return [0] if n <= 0
  return [0, 1] if n == 1
  one_less = fib(n - 1)
  previous1 = one_less[-1]
  previous2 = one_less[-2]
  one_less << previous1 + previous2
  one_less
end


# just for fun
memoized_fib = Hash.new { |h, k| h[k] = h[k-1] + h[k-2] }
memoized_fib[1], memoized_fib[2] = 0, 1


# p fib(0) # [0]
# p fib(1) # [0, 1]
# p fib(2) # [0, 1, 1]
# p fib(3) # [0, 1, 1, 2]

# memoized_fib[8]
# p memoized_fib.values          # slower than fib, however...
# p memoized_fib.values.take(5)  # instant lookup time for memoized items