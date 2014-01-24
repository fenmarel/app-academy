def set_add_el(set, element)
	set.merge({element => true})
end

def set_remove_el(set, element)
	set.delete(element)
	set
end

def set_list_els(set)
	set.keys
end

def set_member?(set, element)
	set.has_key? element
end

def set_union(set1, set2)
	set1.merge(set2)
end

def set_intersection(set1, set2)
	intersections = {}
	set1.keys.each do |key|
		if set2.has_key? key
			intersections[key] = true
		end
	end
	intersections
end

def set_minus(set1, set2)
	final_set = {}
	set1.keys.each do |key|
		if not set2.has_key? key
			final_set[key] = true
		end
	end
	final_set
end


# # Given Tests
# p set_add_el({}, :x) == {:x => true}
# p set_add_el({:x => true}, :x) == {:x => true} 
# p set_remove_el({:x => true}, :x) == {}
# p set_list_els({:x => true, :y => true}) == [:x, :y]
# p set_member?({:x => true}, :x) == true
# p set_union({:x => true}, {:y => true}) == {:x => true, :y => true}
# p set_intersection({x: true, y: true}, {y: true, z: true}) == {y: true}
# p set_minus({x: true, y: true}, {y: true, z: true}) == {x: true}