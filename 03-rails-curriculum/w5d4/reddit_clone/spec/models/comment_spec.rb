require 'spec_helper'

describe Comment do
  describe "associations" do
    it { should have_many :replies }
    it { should belong_to :link }
    it { should belong_to :user }
  end

  describe "validations" do
    let(:comment) { FactoryGirl.build(:comment) }

    it "should be valid with body content" do
      expect(comment).to be_valid
    end

    it "should be invalid without body content" do
      comment.body = " "
      expect(comment).to_not be_valid
    end
  end
end
