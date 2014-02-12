require_relative 'questiondb'
require_relative 'dbobject'


class QuestionFollower < DBObject

  attr_reader :id, :user_id, :question_id

  def self.find_by_id(id)
    query = <<-SQL
    SELECT
      *
    FROM
      question_followers
    WHERE
    id = ?;
    SQL

    QuestionFollower.new(QuestionDB.instance.execute(query, id).first)
  end

  def self.followers_for_question_id(id)
    query = <<-SQL
    SELECT
    users.fname, users.lname
    FROM
    users JOIN question_followers ON question_followers.user_id = users.id
    WHERE
    question_followers.question_id = ?;
    SQL

    QuestionDB.instance.execute(query, id).map do |user|
      User.new(user)
    end
  end

  def self.followed_questions_for_user_id(id)
    query = <<-SQL
    SELECT
    questions.*
    FROM
    questions JOIN question_followers ON question_followers.question_id = questions.id
    WHERE
    question_followers.user_id = ?;
    SQL

    QuestionDB.instance.execute(query, id).map do |question|
      Question.new(question)
    end
  end

  def self.most_followed_questions(n)
    query = <<-SQL
    SELECT
    questions.*
    FROM
    questions JOIN question_followers ON question_followers.question_id = questions.id
    GROUP BY
    questions.id
    ORDER BY
    COUNT(question_followers.user_id) DESC;
    SQL

    QuestionDB.instance.execute(query).map do |question|
      Question.new(question)
    end.shift(n)

  end

  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @param_text = 'user_id, question_id'
    @table = 'question_followers'
  end

  def params
    [@user_id, @question_id]
  end

end