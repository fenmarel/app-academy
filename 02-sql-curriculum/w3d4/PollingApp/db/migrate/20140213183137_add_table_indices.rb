class AddTableIndices < ActiveRecord::Migration
  def change
    add_index(:users, :user_name, unique: true)
    add_index(:polls, :user_id)
    add_index(:questions, :poll_id)
    add_index(:answer_choices, :question_id)
    add_index(:responses, :user_id)
    add_index(:responses, :answer_choice_id)
  end
end
