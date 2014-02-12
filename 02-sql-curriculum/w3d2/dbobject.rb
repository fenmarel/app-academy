require_relative 'questiondb'

class DBObject
  def q_marks(n)
    marks = '('
    n.times { marks << '?, ' }
    marks[0..-3] + ')'
  end

  def set_text
    query_text = ''

    @param_text.split(',').each do |param|
      query_text << "#{param} = ?, "
    end

    query_text[0..-3]
  end

  def save
    @params = self.params

    @id.nil? ? save_record : update_record
  end

  def save_record
    QuestionDB.instance.execute(<<-SQL, *@params)
      INSERT INTO
        #{@table} (#{@param_text})
      VALUES
        #{q_marks(@params.length)}
    SQL

    @id = QuestionDB.instance.last_insert_row_id
  end

  def update_record
    QuestionDB.instance.execute(<<-SQL, *@params, @id)
      UPDATE
        #{@table}
      SET
        #{set_text}
      WHERE
        id = ?;
    SQL

    @id
  end
end