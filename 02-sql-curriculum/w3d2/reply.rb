require_relative 'questiondb'
require_relative 'dbobject'
require_relative 'user'
require_relative 'question'


class Reply < DBObject
  attr_reader :body

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
    @param_text = 'question_id, parent_id, user_id, body'
    @table = 'replies'
  end

  def self.find_by_question_id(id)
    query = <<-SQL
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?;
    SQL

    QuestionDB.instance.execute(query, id).map do |reply|
      Reply.new(reply)
    end

  end

  def self.find_by_user_id(id)
    query = <<-SQL
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?;
    SQL

    QuestionDB.instance.execute(query, id).map do |reply|
      Reply.new(reply)
    end
  end

  def self.find_by_id(id)
    query = <<-SQL
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?;
    SQL

    Reply.new(QuestionDB.instance.execute(query, id).first)
  end

  def params
    [@question_id, @parent_id, @user_id, @body]
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    return nil if @parent_id.nil?

    Reply.find_by_id(@parent_id)
  end

  def child_replies
    query = <<-SQL
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?;
    SQL

    QuestionDB.instance.execute(query, @id).map do |reply|
      Reply.new(reply)
    end
  end
end
