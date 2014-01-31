def eval_bloc(*args, &prc)
  prc.nil? ? prc.call(*args) unless prc.nil? : puts("NO BLOCK GIVEN!")
end

# eval_bloc(1, 2, 3) {|*args| p args}
# eval_bloc(1, 2, 3)