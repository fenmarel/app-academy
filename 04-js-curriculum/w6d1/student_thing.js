function Student(fname, lname) {
  this.fname = fname;
  this.lname = lname;
  this.courseList = [];
};

Student.prototype.name = function() {
  return "" + this.fname + " " + this.lname;
};

Student.prototype.courses = function() {
  return this.courseList;
};

Student.prototype.enroll = function(course) {
  if (course.studentList.indexOf(this) === -1) {
    this.checkConflicts(course);

    this.courseList.push(course);
    course.studentList.push(this);
  } else {
    throw "already registered";
  }
};

Student.prototype.checkConflicts = function(course) {
  for (var i = 0; i < this.courseList.length; i++) {
    if (this.courseList[i].conflictsWith(course)) {
      throw "schedule conflict";
    }
  }
};




function Course(name, department, credits, days, timeBlock) {
  this.name = name;
  this.department= department;
  this.credits = credits;
  this.studentList = [];
  this.days = days;
  this.timeBlock = timeBlock;
};

Course.prototype.students = function() {
  return this.studentList;
};

Course.prototype.addStudent = function(student) {
  student.enroll(this);
};

Course.prototype.conflictsWith = function(course2) {
  for(var i = 0; i < this.days.length; i++) {
    if (course2.days.indexOf(this.days[i]) > -1 &&
        this.timeBlock === course2.timeBlock) {
      return true;
    }
  }
  return false;
};



var stu = new Student("Stu", "Pid");
var c1 = new Course("Ethics", "Philosophy Lee", 8, ['mon', 'tue'], 4);
var c2 = new Course("Pathics", "Philosophy Lee", 8, ['mon', 'tue'], 4);
var c3 = new Course("math", "mathematics", 8, ['wed', 'fri'], 2);
var c4 = new Course("more Ethics", "Philosophy Lee", 8, ['mon', 'tue'], 5);



