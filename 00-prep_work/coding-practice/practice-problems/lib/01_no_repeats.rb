def no_repeats(year_start, year_end)
  (year_start..year_end).to_a.select { |year| no_repeat(year) }
end

def no_repeat(year)
  year_str = year.to_s
  year_str.split('').uniq.join == year_str
end
