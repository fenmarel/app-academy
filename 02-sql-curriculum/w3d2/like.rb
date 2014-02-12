require_relative 'questiondb'
require_relative 'dbobject'
require_relative 'question'
require_relative 'user'



class QuestionLike < DBObject
  attr_reader :id, :user_id, :question_id

  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @param_text = 'user_id, question_id'
    @table = 'question_likes'
  end

  def self.find_by_id(id)
    query = <<-SQL
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?;
    SQL

    QuestionLike.new(QuestionDB.instance.execute(query, id).first)
  end

  def self.likers_for_question_id(id)
    query = <<-SQL
      SELECT
        users.*
      FROM
        users JOIN question_likes
          ON users.id = question_likes.user_id
      WHERE
        question_id = ?;
    SQL

    QuestionDB.instance.execute(query, id).map do |user|
      User.new(user)
    end
  end

  def self.num_likes_for_question_id(id)
    query = <<-SQL
      SELECT
        COUNT(*)
      FROM
        users JOIN question_likes
          ON users.id = question_likes.user_id
      WHERE
        question_id = ?;
    SQL

    QuestionDB.instance.execute(query, id).first["COUNT(*)"]
  end

  def self.liked_questions_for_user_id(id)
    query = <<-SQL
      SELECT
        questions.*
      FROM
        questions JOIN question_likes
          ON questions.id = question_likes.question_id
      WHERE
        user_id = ?;
    SQL

    QuestionDB.instance.execute(query, id).map do |question|
      Question.new(question)
    end
  end

  def self.most_liked_questions(n)
    query = <<-SQL
      SELECT
        questions.*
      FROM
        questions JOIN question_likes
          ON questions.id = question_likes.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_id) DESC;
    SQL

    QuestionDB.instance.execute(query).map do |question|
      Question.new(question)
    end.shift(n)
  end

  def params
    [@user_id, @question_id]
  end
end