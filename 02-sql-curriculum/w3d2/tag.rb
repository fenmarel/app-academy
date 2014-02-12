require_relative 'questiondb'
require_relative 'dbobject'
require_relative 'question'


class Tag < DBObject
  attr_reader :tag_name

  def initialize(options = {})
    @id = options['id']
    @tag_name = options['tag_name']
    @param_text = 'tag_name'
    @table = 'tags'
  end

  def self.most_popular(n)
    query = <<-SQL
      SELECT
        tags.*
      FROM
        tags LEFT OUTER JOIN question_tags
          ON tags.id = question_tags.tag_id
            LEFT OUTER JOIN question_likes
              ON question_tags.question_id = question_likes.question_id
      GROUP BY
        tags.id
      ORDER BY
        COUNT(question_likes.question_id) DESC;
    SQL

    QuestionDB.instance.execute(query).map do |tag|
      Tag.new(tag)
    end.shift(n)
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
          questions JOIN question_tags
            ON question_tags.question_id = questions.id
        WHERE
          question_tags.tag_id = ? ) AS tagquest
            JOIN question_likes
              ON tagquest.id = question_likes.question_id
      GROUP BY
        tagquest.id
      ORDER BY
        count(question_likes.user_id) DESC;
    SQL

    QuestionDB.instance.execute(query, @id).map do |question|
      Question.new(question)
    end.shift(n)
  end
end