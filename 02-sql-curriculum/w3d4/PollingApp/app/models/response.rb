
class Response < ActiveRecord::Base
  validates :answer_choice_id, :presence => true
  validates :user_id, :presence => true

  validate :respondent_has_not_already_answered_question
  validate :creator_not_trying_to_rig_poll

  belongs_to(
    :answer_choice,
    :class_name => "AnswerChoice",
    :primary_key => :id,
    :foreign_key => :anwser_choice_id,
  )

  belongs_to(
    :respondent,
    :class_name => "User",
    :primary_key => :id,
    :foreign_key => :user_id,
  )


  private
  def respondent_has_not_already_answered_question
    check = existing_responses

    unless (check.count == 1 && check.first.id == self.id) || check.empty?
      errors[:response] << "User has already submitted this answer"
    end
  end

  def existing_responses
    Response.find_by_sql([<<-SQL, user_id, answer_choice_id])
    SELECT
      responses.*
    FROM
      responses JOIN answer_choices
        ON responses.answer_choice_id = answer_choices.id
    WHERE
      responses.user_id = ? AND
      answer_choices.question_id IN (
        SELECT
          question_id
        FROM
          answer_choices
        WHERE
          id = ?)
    SQL
  end

  def creator_not_trying_to_rig_poll
    poll_creator_id = User.joins(:polls => {:questions => :answer_choices})
                          .where("answer_choices.id = ?", self.answer_choice_id )
                          .pluck(:id)

    if self.user_id == poll_creator_id.first
      errors[:response] << "Poll creator not allowed to vote on own poll."
    end
  end
end






