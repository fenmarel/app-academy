require 'spec_helper'

describe Sub do

  describe "associations" do
    it { should belong_to :moderator }
    it { should have_many :link_subs }
    it { should have_many :links }
  end

  describe "validations" do
    let(:sub) { FactoryGirl.build(:sub) }

    it "should have have name" do
      expect(sub.name).to be_present
    end

    it "should be invalid without a name" do
      sub.name = " "
      expect(sub).to_not be_valid
    end
  end
end
