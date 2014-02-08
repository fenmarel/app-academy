def stock_picker(stocks)
  days = []
  max = nil

  stocks.each_with_index do |buy, i|
    stocks.each_with_index do |sell, j|
      next if j <= i

      max ||= sell - buy
      if sell - buy > max
        max = sell - buy
        days = [i, j]
      end
    end
  end

  days
end