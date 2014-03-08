(function(root) {
  var SnakeGame = root.SnakeGame = (root.SnakeGame || {});

  var View = SnakeGame.View = function($el) {
    this.el = $el;
    this.interval = 200;
    this.timer;
  };

  View.prototype.start = function() {
    $(document).keydown(function(event) {
      handleKeyEvent(event);
    });

    var that = this;
    this.timer = setInterval(function() { that.step() }, that.interval);
  };

  var handleKeyEvent = function(event) {
    console.log("KEYPRESS");
    switch(event.keyCode) {
    case 87:
      game.snake1.turn('N');
      break;
    case 65:
      game.snake1.turn('W');
      break;
    case 83:
      game.snake1.turn('S');
      break;
    case 68:
      game.snake1.turn('E');
      break;

    // player 2
    case 38:
      game.snake2.turn('N');
      break;
    case 37:
      game.snake2.turn('W');
      break;
    case 40:
      game.snake2.turn('S');
      break;
    case 39:
      game.snake2.turn('E');
      break;
    }
  };

  View.prototype.speedUp = function() {
    clearInterval(this.timer);
    this.interval *= .95;

    var that = this;
    this.timer = setInterval(function() {that.step()}, that.interval);
    console.log(this.interval);
  };

  View.prototype.step = function() {
    game.snake1.moveAndEat();
    game.snake2.moveAndEat();

    if (game.snake1.isCollidedWithSelf() || game.snake2.isCollidedWithSelf()) {
      alert("YOU ATE YOU!");
      location.reload();
    } else if (game.snake1.isOutOfBounds() || game.snake2.isOutOfBounds()) {
      alert("KABOOM!");
      location.reload();
    } else if (game.snake1.isCollidedWithOther(game.snake2)) {
      alert("Snake 2 WINS!");
      location.reload();
    } else if (game.snake2.isCollidedWithOther(game.snake1)) {
      alert("Snake 1 WINS!");
      location.reload();
    }

    this.el.empty();
    var grid = game.render();
    this.el.append("<pre>" + grid + "</pre>");
  };
})(this)



$(document).ready(function() {
  game = new SnakeGame.Board();
  view = new SnakeGame.View($('div'));
  view.start();
})