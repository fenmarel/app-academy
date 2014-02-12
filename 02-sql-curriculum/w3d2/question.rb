require_relative 'questiondb'
require_relative 'dbobject'
require_relative 'follower'
require_relative 'like'
require_relative 'reply'
require_relative 'user'


class Question < DBObject
  attr_reader :title, :body

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
    @param_text = 'title, body, author_id'
    @table = 'questions'
  end

  def self.find_by_id(id)
    query = <<-SQL
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?;
    SQL

    Question.new(QuestionDB.instance.execute(query, id).first)
  end

  def self.find_by_author_id(id)
    query = <<-SQL
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?;
    SQL

    QuestionDB.instance.execute(query, id).map do |question|
      Question.new(question)
    end
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def params
    [@title, @body, @author_id]
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def author
    User.find_by_id(@author_id)
  end

  def followers
    QuestionFollower.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
end