require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }

  describe "associations" do
    it { should have_many :subs }
    it { should have_many :links }
    it { should have_many :comments }
  end

  describe "validations" do

    it "should be invalid without a username" do
      user.username = " "
      expect(user).to_not be_valid
    end

    it "should be invalid with a password less than 6 chars" do
      user.password = "abcd"
      expect(user).to_not be_valid
    end

    it "password should also be valid as nil" do
      user.password = nil
      expect(user).to be_valid
    end
  end

  describe "methods" do

    it "should generate password digest" do
      expect(user.password_digest).to_not be_nil
    end

    it "should check correct password" do
      expect(user.is_password?("password")).to be_true
    end

    it "should ensure a session token" do
      user.save
      expect(user.session_token).to be_present
    end

    it "should reset session token" do
      original = user.session_token
      user.reset_session_token!
      expect(user.session_token).to_not eq original
    end

    it "should return a user" do
      user.update(:username => "weyman")
      expect(User.find_by_credentials("weyman", "password")).to eq(user)
    end
  end
end
