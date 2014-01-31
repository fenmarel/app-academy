def exp1(base, power)
  # 256 calls for power == 256
  return 1 if power == 0
  base * exp1(base, power - 1)
end

def exp2(base, power)
  # 8 calls for power == 256
  return 1 if power == 0

  if power.even?
    exp2(base, power / 2) ** 2
  else
    base *(exp2(base, (power - 1) / 2) ** 2)
  end
end

# p exp1(2, 2)
# p exp1(2, 8)

# p exp2(2, 2)
# p exp2(2, 7)