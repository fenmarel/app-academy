(function(root){
  var Asteroids = root.Asteroids = (root.Asteroids || {});
  var Game = Asteroids.Game = function(ctx){
    this.ctx = ctx;
    this.asteroids = [];
    this.bullets = [];
    this.ship = new Asteroids.Ship([Game.DIMX/2, Game.DIMY/2], [0,0]);
  };

  Game.DIMX = 750;
  Game.DIMY = 500;
  Game.FPS = 60;

  Game.prototype.addAsteroids = function(numAsteroids) {
    for (var i = 0; i < numAsteroids; i++) {
      this.asteroids.push(Asteroids.Asteroid.randomAsteroid(Game.DIMX, Game.DIMY));
    }
  };

  Game.prototype.shipKeyHandlers = function(){
    var that = this;
    var x = 0;
    var y = 0;

    if (key.isPressed('up'))
      y -= .25;
    if (key.isPressed('left'))
      x -= .25;
    if (key.isPressed('down'))
      y += .25;
    if (key.isPressed('right'))
      x += .25;

    this.ship.power([x, y]);
  };

  Game.prototype.bindKeyHandlers = function() {
    var that = this;
    key('space', function(){
            var bullet = that.ship.fireBullet();
            if (bullet){ that.bullets.push(bullet) };
    });
  }


  Game.prototype.checkCollisions = function(){
    var that = this;
    this.asteroids.forEach(function(asteroid){
      if (that.ship.isCollidedWith(asteroid)){
        alert("You ran into an asteroid. Game Over!");
        window.location.reload();
      }
    });
  }


  Game.prototype.draw = function() {
    this.ctx.clearRect(0, 0, Game.DIMX, Game.DIMY);

    var that = this;
    this.asteroids.forEach(function(asteroid) {
      asteroid.draw(that.ctx);
    })

    this.ship.draw(that.ctx);

    this.bullets.forEach(function(bullet) {
      bullet.draw(that.ctx);
    });
  };

  Game.prototype.hitAsteroids = function() {
    var that = this;
    this.asteroids.forEach(function(asteroid){
      that.bullets.forEach(function(bullet){
        if(bullet.isCollidedWith(asteroid)){
          that.removeAsteroid(asteroid);
          that.removeBullet(bullet);
        }
      });
    });
  }

  Game.prototype.move = function() {
    var that = this;

    this.asteroids.forEach(function(asteroid) {
      asteroid.move(Game.DIMX, Game.DIMY);
    });

    this.ship.move(Game.DIMX, Game.DIMY);

    this.bullets.forEach(function(bullet) {
      bullet.move(Game.DIMX, Game.DIMY);
      if (bullet.moves == 100){
        that.removeBullet(bullet);
      }
    });
  };

  Game.prototype.removeAsteroid = function(asteroid){
    var index = this.asteroids.indexOf(asteroid);
    if(index !== -1){
      this.asteroids.splice(index, 1);
    }
  }

  Game.prototype.removeBullet = function(bullet){
    var index = this.bullets.indexOf(bullet);
    if(index !== -1){
      this.bullets.splice(index, 1);
    }
  };

  Game.prototype.start = function() {
    this.bindKeyHandlers();
    this.addAsteroids(10);
    setInterval(this.addAsteroids.bind(this, 1), 1000);
    setInterval(this.step.bind(this), 1000 / Game.FPS);

  }

  Game.prototype.step = function() {
    this.move();
    this.draw();
    this.checkCollisions();
    this.hitAsteroids();
    this.shipKeyHandlers();
  };


})(this);