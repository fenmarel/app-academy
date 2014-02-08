class Tower
  attr_accessor :rows

  def initialize
    @rows = [[3, 2, 1], [],[]]
  end

  def play
    until won?
      display_towers

      print "Choose a tower to take from > "
      take = gets.chomp.to_i - 1

      print "Choose a tower to place disk on > "
      give = gets.chomp.to_i - 1

      move(take, give)
    end

    puts "You win! Yippideedoo!"
  end

  def display_towers
    2.downto(0) do |i|
      (0..2).each do |j|
        check = @rows[j][i].nil? ? " " : @rows[j][i]
        print " #{check} "
      end
      puts
    end
    puts '--tower--'
    puts ' 1  2  3 '

    self
  end

  def move(start, finish)
    return if @rows[start].empty?

    if @rows[finish].empty? || @rows[start].last < @rows[finish].last
      disk = @rows[start].pop
      @rows[finish].push(disk)
    end
  end

  def won?
    @rows == [[],[],[3,2,1]]
  end
end

if $PROGRAM_NAME == __FILE__
  t = Tower.new
  t.play
end
