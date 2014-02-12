require 'sqlite3'
require 'singleton'

class QuestionDB < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')

    self.results_as_hash = true
    self.type_translation = true
  end
end

class DBObject
  def initialize
    @param_text = ''
  end

  def q_marks(n)
    str = '('
    n.times { str << '?,' }
    str[0..-2] + ')'
  end

  def set_text
    str = ''

    @param_text.split(',').each do |param|
      str << "#{param} = ?, "
    end

    str[0..-3]
  end

  def save
    @params = params

    if @id.nil?
      query = <<-SQL
      INSERT INTO
      #{@table} (#{@param_text})
      VALUES
      #{q_marks(@params.length)}
      SQL

      QuestionDB.instance.execute(query, *@params)


      @id = QuestionDB.instance.last_insert_row_id
    else

      QuestionDB.instance.execute(<<-SQL, *@params, @id)
      UPDATE
      #{@table}
      SET
      #{set_text}
      WHERE
      id = ?;
      SQL
    end

  end

end


######### USER ###########
class User < DBObject

  attr_accessor :fname, :lname
  attr_reader :params

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

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
    @param_text = 'fname, lname'
    @table = 'users'
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
      questions LEFT OUTER JOIN question_likes ON question_likes.question_id = questions.id
      WHERE
      questions.author_id = ?
      GROUP BY
    questions.id);
    SQL

    QuestionDB.instance.execute(query, @id).first["AVG(total)"]
  end
end



########## QUESTION  ########

class Question < DBObject

  attr_reader :id, :title, :body, :author_id

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

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
    @param_text = 'title, body, author_id'
    @table = 'questions'
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


######### FOLLOWER  ########
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


######## REPLY ########
class Reply < DBObject

  attr_reader :id, :question_id, :parent_id, :user_id, :body

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

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
    @param_text = 'question_id, parent_id, user_id, body'
    @table = 'replies'
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
    raise "no parent" if @parent_id.nil?

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

class QuestionLike < DBObject

  attr_reader :id, :user_id, :question_id

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
    users JOIN question_likes ON users.id = user_id
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
    users JOIN question_likes on users.id = user_id
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
    questions JOIN question_likes ON questions.id = question_id
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
    questions JOIN question_likes ON questions.id = question_id
    GROUP BY
    questions.id
    ORDER BY
    COUNT(question_id) DESC;
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
    @table = 'question_likes'
  end

  def params
    [@user_id, @question_id]
  end
end

class Tag < DBObject


  def self.most_popular(n)

    query = <<-SQL
    SELECT
    tags.*
    FROM
    tags LEFT OUTER JOIN question_tags ON tags.id = question_tags.tag_id
    LEFT OUTER JOIN question_likes ON question_tags.question_id = question_likes.question_id
    GROUP BY
    tags.id
    ORDER BY
    COUNT(question_likes.question_id) DESC;
    SQL

    QuestionDB.instance.execute(query).map do |tag|
      Tag.new(tag)
    end.shift(n)

  end


  def initialize(options = {})
    @id = options['id']
    @tag_name = options['tag_name']
    @param_text = 'tag_name'
    @table = 'tags'
  end

  def params
    [@tag_name]
  end


  def most_popular_questions(n)
    query = <<-SQL
    SELECT
    tagquest.*
    FROM
    ( SELECT
    questions.*
    FROM
    questions JOIN question_tags ON question_tags.question_id = questions.id
    WHERE
  question_tags.tag_id = ? ) AS tagquest JOIN question_likes ON tagquest.id = question_likes.question_id
  GROUP BY
    tagquest.id
  ORDER BY count(question_likes.user_id) DESC;
    SQL

    QuestionDB.instance.execute(query, @id).map do |question|
      Question.new(question)
    end.shift(n)

  end

end