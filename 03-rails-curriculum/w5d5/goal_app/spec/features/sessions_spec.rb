require 'spec_helper'

feature "User Creation" do
  let(:new_user) { FactoryGirl.build(:user) }

  it "has a new user page" do
    visit new_user_url
    expect(page).to have_content "Sign Up"
  end

  feature "signing up a user" do
    before(:each) do
      sign_up_random_user
    end

    it "redirects to user show page after successful login" do
      expect(page).to have_content "#{new_user.username}'s Page"
    end
  end
end

feature "Session Management" do
  let(:new_user) { FactoryGirl.build(:user) }

  it "has a sign in page" do
    visit new_session_url
    expect(page).to have_content "Sign In"
  end

  feature "signing in a user" do
    before(:each) do
      sign_up_user(new_user.username, new_user.password)
      click_button "Sign Out"

      visit new_session_url
      fill_in 'username', :with => new_user.username
      fill_in 'password', :with => new_user.password
      click_button "Sign In"
    end

    it "redirects to user show page after successful login" do
      expect(page).to have_content "#{new_user.username}'s Page"
    end
  end

  feature "signing out a user" do
    before(:each) do
      sign_up_user(new_user.username, new_user.password)
    end

    it "displays a 'Sign Out' button" do
      expect(page).to have_button "Sign Out"
    end

    it "signs out a logged in user" do
      click_button "Sign Out"
      current_path.should == new_session_path
    end

    it "doesn't show username on page after logout" do
      click_button "Sign Out"
      expect(page).to_not have_content(new_user.username)
    end
  end

end

