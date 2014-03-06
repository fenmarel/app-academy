(function(root) {
  var Asteroids = root.Asteroids = (root.Asteroids || {});
  var Bullet = Asteroids.Bullet = function(pos, vel) {
    Asteroids.MovingObject.call(this, pos, vel, Bullet.RADIUS, Bullet.COLOR);

    this.moves = 0;
  }

  Bullet.inherits(Asteroids.MovingObject);

  Bullet.COLOR = 'black';
  Bullet.RADIUS = 2;

  Bullet.prototype.move = function(dimX, dimY) {
    Asteroids.MovingObject.prototype.move.call(this, dimX, dimY);
    this.moves += 1;
  }




})(this);