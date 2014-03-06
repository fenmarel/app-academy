

(function(root) {
  var Asteroids = root.Asteroids = (root.Asteroids || {});
  var Asteroid = Asteroids.Asteroid = function(pos, vel, radius, color) {
    Asteroids.MovingObject.call(this, pos, vel, radius, color);
  }

  Asteroid.inherits(Asteroids.MovingObject);

  // Asteroid Properties
  Asteroid.COLORS = ['pink', 'blue', 'green', 'red'];
  Asteroid.RADIUS = 25;
  Asteroid.SPEED = 2;
  var randomVec = function(){
    var randX;
    var randY;

    if (Math.random() > 0.5) {
      randX = Math.floor(1 + Math.random() * Asteroid.SPEED)
    } else {
      randX = -Math.floor(1 + Math.random() * Asteroid.SPEED)
    }

    if (Math.random() > 0.5) {
      randY = Math.floor(1 + Math.random() * Asteroid.SPEED)
    } else {
      randY = -Math.floor(1 + Math.random() * Asteroid.SPEED)
    }

    return [randX, randY];
  }


  Asteroid.randomAsteroid = function(dimX, dimY) {
    var randX = Math.floor(Math.random() * dimX);
    var randY = Math.floor(Math.random() * dimY);
    var color = Asteroid.COLORS[Math.floor(Math.random() * Asteroid.COLORS.length)];
    var radius = Math.floor(Math.random() * Asteroid.RADIUS + 10);
    var vel = randomVec();
    return new Asteroid([randX, randY], vel, radius, color);
  }

})(this)