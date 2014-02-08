require 'rspec'
require 'array'


describe Array do
  describe "#my_unique" do
    it "should return uniq when given an array" do
      expect([1, 2, 1, 3, 3].my_uniq).to eq([1, 2, 3])
      expect([1, 1, 1, 1].my_uniq).to eq([1])
    end
  end

  describe "#two_sum" do
    it "should return indices of array pairs that sum to zero" do
      expect([-1, 0, 2, -2, 1].two_sum).to eq([[0,4],[2,3]])
    end

    it "should return an empty array if no zero sums are found" do
      expect([1, 2, 3, 0, 4, 5].two_sum).to eq([])
    end
  end

  describe "#my_transpose" do
    let(:square) { [[0, 1, 2], [3, 4, 5], [6, 7, 8]] }
    let(:square_t) { [[0, 3, 6], [1, 4, 7], [2, 5, 8]] }

    let(:non_square) { [[0, 1, 2], [3, 4, 5]] }
    let(:non_square_t) { [[0, 3], [1, 4], [2, 5]] }

    it "should return empty array for a transposed empty array" do
      expect([].my_transpose).to eq([])
    end

    it "should transpose a square matrix" do
      expect(square.my_transpose).to eq(square_t)
    end

    it "should transpose a non-square matrix" do
      expect(non_square.my_transpose).to eq(non_square_t)
    end

    it "should raise an exception if called on a 1d array" do
      expect { [1, 2, 3].my_transpose }.to raise_error(TypeError)
    end
  end
end
