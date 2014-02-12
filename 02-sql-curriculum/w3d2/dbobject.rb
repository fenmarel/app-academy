require_relative 'questiondb'

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