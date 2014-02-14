# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = User.create!(:user_name => "foo")
creator = User.create!(:user_name => "the creator")

p = Poll.create!(:title => "Some Poll", :user_id => creator.id)

q = Question.create!(:poll_id => p.id, :text => "Who, what where?")

ac = AnswerChoice.create!(:question_id => q.id, :answer => "Because")

Response.create!(:user_id => u.id, :answer_choice_id => ac.id)

u2 = User.create!(:user_name => "bar")
u3 = User.create!(:user_name => "baz")

ac2 = AnswerChoice.create!(:question_id => q.id, :answer => "Why not?")

ac3 = AnswerChoice.create!(:question_id => q.id, :answer => "Because lonly")

Response.create!(:user_id => u2.id, :answer_choice_id => ac.id)
Response.create!(:user_id => u3.id, :answer_choice_id => ac2.id)