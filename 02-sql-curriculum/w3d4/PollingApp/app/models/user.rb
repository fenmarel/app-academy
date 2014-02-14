
class User < ActiveRecord::Base
  validates :user_name, :uniqueness => true

  has_many(
    :polls,
    :class_name => "Poll",
    :primary_key => :id,
    :foreign_key => :user_id
  )

  has_many(
    :responses,
    :class_name => "Response",
    :primary_key => :id,
    :foreign_key => :user_id
  )

  def completed_polls
    Poll.find_by_sql([<<-SQL, self.id])
      SELECT
        a.id
      FROM (
        SELECT
          polls.*, COUNT(responses.id) AS res_num
        FROM
          polls JOIN questions
            ON polls.id = questions.poll_id
             JOIN answer_choices
               ON questions.id = answer_choices.question_id
                 JOIN responses
                   ON answer_choices.id = responses.answer_choice_id
        WHERE
          responses.user_id = ?
        GROUP BY
          polls.id) AS a
          JOIN (
            SELECT
              poll_id, COUNT(id) AS q_num
            FROM
              questions
            GROUP BY
              poll_id) AS b
          ON b.poll_id = a.id
        WHERE
        a.res_num = b.q_num
    SQL
  end

  def uncompleted_polls
    Poll.find_by_sql([<<-SQL, self.id])
    SELECT
      id
    FROM
      polls
    WHERE
      id NOT IN (
        SELECT
          a.id
        FROM (
          SELECT
            polls.*, COUNT(responses.id) AS res_num
          FROM
            polls JOIN questions
              ON polls.id = questions.poll_id
               JOIN answer_choices
                 ON questions.id = answer_choices.question_id
                   JOIN responses
                     ON answer_choices.id = responses.answer_choice_id
          WHERE
            responses.user_id = ?
          GROUP BY
            polls.id) AS a
            JOIN (
              SELECT
                poll_id, COUNT(id) AS q_num
              FROM
                questions
              GROUP BY
                poll_id) AS b
            ON b.poll_id = a.id
          WHERE
            a.res_num = b.q_num)
    SQL
  end

end