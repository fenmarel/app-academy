var Piece = require("./piece.js").Piece;

function Board() {
  this.grid = [Array(8), Array(8), Array(8), Array(8),
               Array(8), Array(8), Array(8), Array(8)];

  this.grid[3][3] = new Piece("black");
  this.grid[3][4] = new Piece("white");
  this.grid[4][4] = new Piece("black");
  this.grid[4][3] = new Piece("white");


  this.directions = [[0, 1], [1, 1], [1, 0], [1, -1],
                     [0, -1], [-1, -1], [-1, 0], [-1, 1]];
}

Board.prototype.full = function () {
  for (var i = 0; i < this.grid.length; i++) {
    for (var j = 0; j < this.grid[0].length; j++) {
      if (!this.grid[i][j]) {
        return false;
      }
    }
  }

  return true;
};

Board.prototype.show = function() {
  for (var j = 0; j < this.grid.length; j++){
    var row = this.grid[j];
    var displayRow = [];

    for (var i = 0; i < row.length; i++) {
      displayRow.push(row[i] ? row[i].color[0] : "_");
    }
    console.log([j].concat(displayRow));
  }
  console.log(['', '0', '1', '2', '3', '4', '5', '6', '7']);
};

Board.prototype.movesLeft = function(color) {
  for (var i = 0; i < this.grid.length; i ++) {
    for (var j = 0; j < this.grid[0].length; j++) {
      if (this.validMove([i, j], color)) {
        return true;
      }
    }
  }

  return false;
}

Board.prototype.capture = function(pos, color) {
  var that = this;
  var posArr = [+pos[0], +pos[2]];

  this.grid[posArr[0]][posArr[1]] = new Piece(color);


  this.directions.forEach(function(dir) {
    var checked = that.checkDirection(posArr, color, dir);

    if (checked) {
      that.piecesBetween(posArr, checked, dir).forEach(function(piece) {
        piece.flip();
      })
    }
  })
}

Board.prototype.piecesBetween = function(pos1, pos2, dir) {
  var pieces = []
  pos1 = [pos1[0] + dir[0], pos1[1] + dir[1]];

  while (pos1.toString() !== pos2.toString()) {
    pieces.push(this.grid[pos1[0]][pos1[1]]);
    pos1 = [pos1[0] + dir[0], pos1[1] + dir[1]];
  }

  return pieces;
}

Board.prototype.checkDirection = function(pos, color, dir) {
  var currentPos = [pos[0] + dir[0], pos[1] + dir[1]]

  var checkSpace;
  if (this.grid[currentPos[0]] && this.grid[currentPos[1]]) {
   checkSpace = this.grid[currentPos[0]][currentPos[1]];
  } else {
    checkSpace = false;
  }

  if(checkSpace && checkSpace.color === this.other(color)) {
    while (checkSpace && checkSpace.color === this.other(color)) {
      currentPos = [currentPos[0] + dir[0], currentPos[1] + dir[1]];
      checkSpace = this.grid[currentPos[0]][currentPos[1]];
    }

    if (checkSpace && checkSpace.color == color) {
      return currentPos;
    }
  }

  return false;
}

Board.prototype.other = function(color) {
  return (color === "white") ? "black" : "white";
}

Board.prototype.validMove = function(pos, color) {
  var posArr = [+pos[0], +pos[2]];

  if (this.grid[posArr[0]][posArr[1]]) {
    return false;
  }

  for (var i = 0; i < this.directions.length; i++) {
    if (this.checkDirection(posArr, color, this.directions[i])) {
      return true;
    }
  }

  return false;
}
// Other helper methods may be helpful!

exports.Board = Board;
