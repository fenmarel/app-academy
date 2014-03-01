require 'spec_helper'

feature "Goal Creation" do
  let(:new_goal) { FactoryGirl.build(:goal) }

  before(:each) do
    sign_up_user("foobar", "foobar")
  end

  it "has a link to create a new goal on the user show page" do
    expect(page).to have_link "Create New Goal"
  end

  it "has a form to create a new goal" do
    click_link "Create New Goal"
    expect(page).to have_content "Add a New Goal!"
    expect(page).to have_content "Title"
    expect(page).to have_content "Description"
  end

  it "has a checkbox to mark a goal as 'private'" do
    click_link "Create New Goal"
    check "Private Goal"
  end

  it "displays errors if not given a title" do
    click_link "Create New Goal"
    fill_in "Description", :with => new_goal.description
    click_button "Create New Goal"

    expect(page).to have_content("can't be blank")
  end

  it "displays errors if not given a description" do
    click_link "Create New Goal"
    fill_in "Title", :with => new_goal.title
    click_button "Create New Goal"

    expect(page).to have_content("can't be blank")
  end

  it "creates a goal upon form submission" do
    click_link "Create New Goal"
    fill_in "Title", :with => new_goal.title
    fill_in "Description", :with => new_goal.description
    click_button "Create New Goal"

    expect(page).to have_content(new_goal.title)
    expect(page).to have_content(new_goal.description)
  end

  it "creates a private goal upon form submission with private box checked" do
    click_link "Create New Goal"
    fill_in "Title", :with => new_goal.title
    fill_in "Description", :with => new_goal.description
    check "Private Goal"
    click_button "Create New Goal"
    expect(page).to have_content("private goal")
  end
end


feature "Goal Manipulation" do
  let(:new_goal) { FactoryGirl.build(:goal) }

  before(:each) do
    sign_up_user("foobar", "foobar")

    create_new_goal(new_goal)
  end

  it "should have an edit button" do
    expect(page).to have_link("Edit Goal")
  end

  it "should have an edit page" do
    click_link "Edit Goal"
    expect(page).to have_content("Edit your Goal")
  end

  it "should prefill info" do
    click_link "Edit Goal"
    expect(find_field('Title').value).to have_content(new_goal.title)
    expect(find_field('Description').value).to have_content(new_goal.description)
  end

  it "should display revisions upon successful edit" do
    click_link "Edit Goal"
    fill_in "Title", :with => "This is an updated title"
    fill_in "Description", :with => "This is an updated description"
    click_button "Update Goal"
    expect(page).to have_content("This is an updated title")
    expect(page).to have_content("This is an updated description")
    expect(page).to have_content("Goal successfully updated!")
  end

  it "clicking 'back' redirects to user goals" do
    click_link "<< Back"
    expect(page).to have_content "foobar's Page"
  end

  it "should display open goals" do
    click_link "<< Back"
    expect(find(:css, '.incomplete_goals div a').text).to eq(new_goal.title)
  end

  it "should display completed goals" do
    click_button "Complete Goal!"
    expect(find(:css, '.completed_goals div a').text).to eq(new_goal.title)
  end

  it "should delete a goal" do
    click_button "Remove Goal"
    expect(page).to_not have_content(new_goal.title)
  end

end



feature "Private Goal Display" do

  let(:beavis) { FactoryGirl.create(:user, :username => "beavis", :password => "hehehe") }
  let(:butthead) { FactoryGirl.create(:user, :username => "butthead", :password => "huhuhu") }

  before(:each) do
    sign_in_user(beavis)
    click_link "Create New Goal"
    fill_in "Title", :with => "FIRE!"
    fill_in "Description", :with => "Fire is cool!"
    check "Private Goal"
    click_button "Create New Goal"
    click_button "Sign Out"

    sign_in_user(butthead)
  end

  it "prevents other users from viewing another user's private goals" do
    visit user_url(beavis)
    expect(page).to_not have_content(beavis.goals.first.title)
  end

end












