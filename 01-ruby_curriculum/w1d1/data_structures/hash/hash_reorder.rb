def correct_hash(hash)
	new_hash = {}
	hash.values.each do |val|
		new_hash[val[0].to_sym] = val
	end
	new_hash
end



wrong_hash = { :a => "banana", :b => "cabbage", :c => "dental_floss", :d => "eel_sushi" }
p correct_hash(wrong_hash)