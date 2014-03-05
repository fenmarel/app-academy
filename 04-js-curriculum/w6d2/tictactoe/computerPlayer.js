var Board = require('./board.js').TicTacToe.Board;

(function(root) {
  var TicTacToe = root.TicTacToe = (root.TicTacToe || {});

  var ComputerPlayer = TicTacToe.ComputerPlayer = function(mark, board) {
    this.mark = mark;
    this.board = board;
  };

  ComputerPlayer.prototype.getMove = function(callback) {
    var pos = Math.floor(Math.random() * 9);
    var winMove = this.winnable();

    if (winMove) {
      pos = winMove;
    }

    if (this.board.empty(pos)) {
      this.board.placeMark(pos, this.mark);
      callback();
    } else {
      this.getMove(callback);
    }
  };

  ComputerPlayer.prototype.winnable = function() {
    var empties = this.board.emptySpaces();

    for (var i = 0; i < empties.length; i++) {
      var dupBoard = new Board();
      dupBoard.grid = this.board.grid.slice(0);
      dupBoard.placeMark(empties[i], this.mark);
      if (dupBoard.won()) {
        return empties[i];
      }
    }

    return false;
  };

})(this)
