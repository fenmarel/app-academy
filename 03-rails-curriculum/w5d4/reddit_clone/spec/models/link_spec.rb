require 'spec_helper'

describe Link do

  describe "association" do
    it { should have_many :link_subs }
    it { should have_many :subs }
    it { should belong_to :user }
    it { should have_many :comments }
  end

  describe "validations" do
    let(:link) { FactoryGirl.build(:link) }

    it "should have a title" do
      link.title = " "
      expect(link).to_not be_valid
    end

    it "should have a url"  do
      link.url = " "
      expect(link).to_not be_valid
    end
  end
end
