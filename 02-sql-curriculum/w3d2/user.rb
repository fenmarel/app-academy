require_relative 'questiondb'
require_relative 'dbobject'
require_relative 'question'
require_relative 'reply'
require_relative 'follower'
require_relative 'like'


class User < DBObject
  attr_accessor :fname, :lname

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
    @param_text = 'fname, lname'
    @table = 'users'
  end

  def self.find_by_id(id)
    query = <<-SQL
      SELECT
        *
      FROM
        users
      WHERE
        id = ?;
    SQL

    User.new(QuestionDB.instance.execute(query, id).first)
  end

  def self.find_by_name(fname, lname)
    query = <<-SQL
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?;
    SQL

    User.new(QuestionDB.instance.execute(query, fname, lname).first)
  end

  def params
    [@fname, @lname]
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    query = <<-SQL
      SELECT
        AVG(total)
      FROM (
        SELECT
          questions.id, COUNT(question_likes.user_id) total
        FROM
          questions LEFT OUTER JOIN question_likes
            ON question_likes.question_id = questions.id
        WHERE
          questions.author_id = ?
        GROUP BY
          questions.id);
    SQL

    QuestionDB.instance.execute(query, @id).first["AVG(total)"]
  end
end