class Student
  attr_reader :name, :courses, :schedule

  def initialize(first_name, last_name)
    @first_name, @last_name = first_name, last_name
    @courses = []
    @schedule = Hash.new { |hash, k| hash[k] = [] }
  end

  def name
    "#{@first_name} #{@last_name}"
  end

  def enroll(course)
    unless courses_conflicts_with?(course)
      @courses << course
      course.add_student(self)

      # set schedule
      course.days.each do |day|
        @schedule[day] << course.time
      end
    else
      puts "Conflicting course enrollment for #{course.name}."
    end
  end

  def courses_conflicts_with?(course)
    # will return true for duplicate classes, and time conflicts
    course.days.each do |day|
      return true if @schedule[day].include?(course.time)
    end
    false
  end

  def course_load
    Hash.new(0).tap do |load|
      @courses.each do |course|
        load[course.dept] += course.credit
      end
    end
  end
end

class Course
  attr_reader :students, :name, :dept, :credit, :days, :time
  
  def initialize(name, dept, credit, days, time)
    @name = name
    @dept = dept
    @credit = credit
    @days = days
    @time = time
    @students = []
  end

  def add_student(student)
    @students << student
  end
end


# s = Student.new("jon", "skrip")
# c = Course.new("CS", "eng", 4, [:mon, :wed, :fri], 3)
# c2 = Course.new("C2", "eng", 4, [:mon], 3)
# c3 = Course.new("C3", "eng", 4, [:mon], 1)
# s.enroll(c)
# s.enroll(c2)
# s.enroll(c3)
# p s.schedule