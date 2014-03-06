(function(root) {
  var Asteroids = root.Asteroids = (root.Asteroids || {});
  var Ship = Asteroids.Ship = function(pos, vel) {
    Asteroids.MovingObject.call(this, pos, vel, Ship.RADIUS, Ship.COLOR);
  };

  Ship.inherits(Asteroids.MovingObject);

  Ship.RADIUS = 10;
  Ship.COLOR = 'black';

  Ship.prototype.power = function(impulse){
    if (Math.abs(this.velX + impulse[0]) <= 5){
      this.velX += impulse[0];
    }
    if (Math.abs(this.velY + impulse[1]) <= 5){
      this.velY += impulse[1];
    }
  }

  Ship.prototype.fireBullet = function() {
    if (this.velX !== 0 || this.velY !== 0){
    return new Asteroids.Bullet([this.posX, this.posY],
                                [this.velX * 2, this.velY * 2]);
    }
  }



})(this);