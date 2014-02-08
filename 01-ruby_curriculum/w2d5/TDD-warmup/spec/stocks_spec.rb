require 'rspec'
require 'stocks'


describe "stock picker" do
  it "should return empty array if passed an empty array" do
    expect(stock_picker([])).to eq([])
  end

  it "should return empty array if 0 profit is the best outcome" do
    expect(stock_picker([5, 4, 3, 2, 1])).to eq([])
  end

  it "should not allow sell before buy" do
    expect(stock_picker([9, 1, 2, 3])).to_not eq([1, 0])
  end

  it "should pick optimal buy/sell days" do
    expect(stock_picker([9, 1, 2, 3, 9])).to eq([1, 4])
  end
end