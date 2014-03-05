function Clock() {}

Clock.prototype.showTime = function() {
  this.incrTime(5);
  console.log(this.currentTime);
};

Clock.prototype.incrTime = function(seconds) {
  this.currentTime.setSeconds(this.currentTime.getSeconds() + seconds);
};

Clock.prototype.run = function() {
  this.currentTime = new Date();
  setInterval(this.showTime.bind(this), 5000);
};

var c = new Clock();
c.run();