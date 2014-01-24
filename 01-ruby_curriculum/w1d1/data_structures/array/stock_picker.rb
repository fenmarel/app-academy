def stock_picker(prices)
	best_days = [0, 0]
	best_price = 0
	prices.each_index do |buy|
		(buy...prices.length).each do |sell|
			if prices[sell] - prices[buy] > best_price
				best_days = [buy + 1, sell + 1]
				best_price = prices[sell] - prices[buy]
			end
		end
	end
	puts "The best combo was to buy on day #{best_days[0]}, and sell on day #{best_days[1]}"
	puts "Doing so would give the optimal profit of $#{best_price}"
end


# stock_picker([3, 2, 1, 4, 6, 2, 3, 9, 3, 4])