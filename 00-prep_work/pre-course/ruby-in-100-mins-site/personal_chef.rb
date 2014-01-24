require 'date'

class PersonalChef
  def initialize
    @meals = %w[breakfast lunch dinner dessert]
  end
  
  def gameplan(plan=@meals)
    print "Greeting sir, "
    plan.each { |meal| print "we shall have #{meal}, \nthen " }
    puts "we will be ending food service."
  end
  
   def inventory
    produce = {apples: 3, oranges: 1, carrots: 12}
    produce.each do |item, quantity|
      puts "There are #{quantity} #{item} in the fridge."
    end
  end
  
  def countdown(counter)
    until counter == 0
      puts "The counter is #{counter}"
      counter = counter - 1
    end
    return self
  end
  
  def water_status(minutes)
    if minutes < 7
      puts "The water is not boiling yet."
    elsif minutes == 7
      puts "It's just barely boiling"
    elsif minutes == 8
      puts "It's boiling!"
    else
      puts "Hot! Hot! Hot!"
    end
    return self
  end

  def make_toast(color)
    if color.nil?
      puts "How am I supposed to make nothingness toast?"
    else
      puts "Making your toast #{color}!"
    end
    return self
  end
  
  def make_milkshake(flavor)
    puts "Bringin' all the boys to the yard with mah #{flavor} shake!"
    return self
  end
  
  def make_eggs(quantity)
    quantity.times do |egg|
      puts "Making egg number #{egg+1}!"
    end
    puts "All done!"
    return self
  end
  
  def make(*items)
    if items.length > 1
      tmp = items.pop
      puts "Making your #{items.join(", ")} and #{tmp}, post haste!"
    else
      puts "Making your #{items.to_s}, pronto!"
    end
    return self
  end
  
  def good_morning
    date = Date.today
    puts "Happy #{date.strftime('%A')}, it's day #{date.yday} of #{date.year}!"
    return self
  end
end

class Butler
  def open_front_door
    puts "Ladies and gentlemen, Mr Burt Bacharach"
    return self
  end
  
  def open_door(door)
    puts "Opening the #{door} door!"
    return self
  end
end


kiki = PersonalChef.new
kiki.good_morning
kiki.gameplan
kiki.make_toast('burnt').make_toast('floppy').make('eggs', 'juice', 'bacon', 'ham')
kiki.make_eggs(3)
kiki.make_milkshake('vanilla')

jeeves = Butler.new
jeeves.open_front_door
jeeves.open_door('back')
