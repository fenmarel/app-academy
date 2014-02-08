require 'rspec'
require 'towers'

describe Tower do
  subject(:tower) { Tower.new }

  it "should have an array of 3 elements to hold disks" do
    expect(tower.rows.count).to be(3)
  end

  context "#move" do

    before(:each) { tower.move(0, 1) }

    it "should move top disk to right" do
      expect(tower.rows).to eq([[3, 2], [1], []])
    end

    it "should allow smaller disk to be placed on top of larger disk" do
      tower.move(1, 0)
      expect(tower.rows).to eq([[3, 2, 1], [], []])
    end

    it "should not allow bigger disk to be placed on top of smaller disk" do
      tower.move(0, 1)
      expect(tower.rows).to eq([[3, 2], [1], []])
    end

    it "should not allow move from empty tower" do
      tower.move(2, 1)
      expect(tower.rows).to eq([[3, 2], [1], []])
    end
  end

  context "#won?" do

    it "should know when you win" do
      tower.rows = ([[],[],[3,2,1]])
      expect(tower.won?).to be(true)
    end

    it "should not tell you that you won if you didn't" do
      expect(tower.won?).to be(false)
    end

    it "should not tell you that you won all disks not on the final tower" do
      tower.rows = ([[],[3,2,1],[]])
      expect(tower.won?).to be(false)
    end
  end

end