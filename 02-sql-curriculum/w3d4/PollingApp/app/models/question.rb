class Question < ActiveRecord::Base
  validates :text, :presence => true
  validates :poll_id, :presence => true


  belongs_to(
    :poll,
    :class_name => "Poll",
    :primary_key => :id,
    :foreign_key => :poll_id
  )

  has_many(
    :answer_choices,
    :class_name => "AnswerChoice",
    :primary_key => :id,
    :foreign_key => :question_id,
    :dependent => :destroy
  )

  def results
    answer_table = self.answer_choices.includes(:responses)

    counts = {}
    answer_table.each do |answer|
      counts[answer.answer] = answer.responses.length
    end

    counts
  end
end