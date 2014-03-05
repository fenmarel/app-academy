var Piece = require("./piece.js").Piece;
var Board = require("./board.js").Board;
var readline = require('readline');

var READER = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});


function Game() {
  this.board = new Board();
  this.currentColor = "black";
}

// You will certainly need some more helper methods...

Game.prototype.won = function () {
  this.board.full() ||
  !this.board.movesLeft("black") ||
  !this.board.movesLeft("white");
};

Game.prototype.placePiece = function (pos, color) {
  if (this.board.validMove(pos, color)) {
    this.board.capture(pos, color);
    return true;
  }
  console.log("Invalid Move");
  return false;
};

Game.prototype.runLoop = function () {

};

Game.prototype.getMove = function() {
  var that = this;
  this.board.show();

  READER.question("Choose a move (format: 1,2) > ", function(pos) {
    if (!that.placePiece(pos, that.currentColor)) {
      that.getMove();
    } else if (that.won()) {
      console.log("WINNER!");
      READER.close();
    } else {
      that.switchColor();
      that.getMove();
    }
  })
}

Game.prototype.switchColor = function() {
  this.currentColor = (this.currentColor === "white") ? "black" : "white";
}

exports.Game = Game;

g = new Game();
g.getMove();
