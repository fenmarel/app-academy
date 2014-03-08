// Note: idealy segments should probably be their own object

(function(root) {
  var SnakeGame = root.SnakeGame = (root.SnakeGame || {});

  var Snake = SnakeGame.Snake = function(coord, dir) {
    this.dir = dir;
    this.segments = [[coord, dir]];
  };


  Snake.prototype.moveAndEat = function() {
    var currentDir = this.dir;

    var lastSegment = this.segments[this.segments.length-1];
    var lastCoord = new Coord(lastSegment[0].x, lastSegment[0].y);
    var possibleGrowthSegment = [lastCoord, lastSegment[1]];

    if (this.segmentToAdd) {
      this.segments.push(this.segmentToAdd);
      this.segmentToAdd = undefined;
    }

    for (var i=0; i<this.segments.length; i++) {
      var segment = this.segments[i]
      var coord = segment[0];
      var tempDir = segment[1];

      coord.plus(currentDir);
      segment[1] = currentDir;

      currentDir = tempDir;
    }

    var segment = this.segments[0];
    var coord = segment[0];

    if (game.apple && coord.equal(game.apple)) {
      this.segmentToAdd = possibleGrowthSegment;
      game.placeApple();
      view.speedUp();
    }
  };


  Snake.prototype.isCollidedWithSelf = function() {
    if (this.segments.length <= 1) {
      return false;
    }

    var head = this.segments[0];
    var headCoord = head[0];
    for (var i = 1; i < this.segments.length; i++) {
      var body = this.segments[i][0];
      if (headCoord.equal(body)) {
        return true;
      }
    }

    return false;
  };


  Snake.prototype.isOutOfBounds = function() {
    var head = this.segments[0];
    var headCoord = head[0];

    if (headCoord.x === Board.GRID_SIZE ||
        headCoord.y === Board.GRID_SIZE ||
        headCoord.x < 0 || headCoord.y < 0) {
      return true;
    }
    return false;
  };


  Snake.prototype.isOnSnake = function(coord) {
    for (var i=0; i<this.segments.length; i++) {
      var segment = this.segments[i];
      var snake_coord = segment[0];
      if (snake_coord.equal(coord)) {
        return true;
      }
    }
    return false;
  };


  Snake.prototype.turn = function(dir) {
    if (this.dir === 'N' && dir === 'S') return;
    if (this.dir === 'S' && dir === 'N') return;
    if (this.dir === 'E' && dir === 'W') return;
    if (this.dir === 'W' && dir === 'E') return;

    this.dir = dir;
  };


  Snake.prototype.isCollidedWithOther = function(otherSnake) {
    var head = this.segments[0][0];
    for (var i = 0; i < otherSnake.segments.length; i++) {
      var otherBody = otherSnake.segments[i][0];
      if (otherBody.equal(head)) {
        return true;
      }
    }
    return false;
  };



  var Coord = SnakeGame.Coord = function(x, y) {
    this.x = x;
    this.y = y;
  };


  Coord.prototype.plus = function(dir) {
    switch(dir) {
    case 'N':
      this.y -= 1;
      break;
    case 'E':
      this.x += 1;
      break;
    case 'S':
      this.y += 1;
      break;
    case 'W':
      this.x -= 1;
      break;
    }
  };


  Coord.prototype.equal = function(otherCoord) {
    return (this.x === otherCoord.x && this.y === otherCoord.y);
  };



  var Board = SnakeGame.Board = function() {
    this.grid = this.makeGrid();
    this.snake1 = new Snake(new Coord(1, 1), 'S');
    this.snake2 = new Snake(new Coord(Board.GRID_SIZE - 2, Board.GRID_SIZE - 2), 'N');
    this.placeApple();
  };


  Board.GRID_SIZE = 20;


  Board.prototype.makeGrid = function() {
    var grid = [];

    for (var i = 0; i < Board.GRID_SIZE; i++) {
      grid.push([]);
      for (var j = 0; j < Board.GRID_SIZE; j++) {
        grid[i].push('.');
      }
    }

    return grid;
  };


  Board.prototype.placeApple = function() {
    while (true) {
      var x = Math.floor(Math.random()*Board.GRID_SIZE);
      var y = Math.floor(Math.random()*Board.GRID_SIZE);

      var apple = new Coord(x, y);

      if (!this.snake1.isOnSnake(apple) && !this.snake2.isOnSnake(apple)) {
        this.apple = apple;
        return;
      }
    }
  };



  Board.prototype.render = function() {
    var grid = this.makeGrid();

    for (var i= 0; i < this.snake1.segments.length; i++) {
      var segment = this.snake1.segments[i];
      var coord = segment[0];
      grid[coord.y][coord.x] = "s";
    }
    for (var i= 0; i < this.snake2.segments.length; i++) {
      var segment = this.snake2.segments[i];
      var coord = segment[0];
      grid[coord.y][coord.x] = "x";
    }

    if (this.apple) {
      var x = this.apple.x;
      var y = this.apple.y;
      grid[y][x] = "O";
    }

    var displayGrid = "";

    for (var i=0; i<grid.length; i++) {
      var row = grid[i];
      displayGrid += row.join(' ') + "\n";
    }
   return displayGrid;
  };
})(this)



















