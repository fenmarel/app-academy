var Board = require('./board.js').TicTacToe.Board;
var HumanPlayer = require('./humanPlayer.js').TicTacToe.HumanPlayer;
var ComputerPlayer = require('./computerPlayer.js').TicTacToe.ComputerPlayer;

(function(root) {
  var TicTacToe = root.TicTacToe = (root.TicTacToe || {});

  var Game = TicTacToe.Game = function() {
    this.board = new Board();
    this.player1 = new HumanPlayer("x", this.board);
    this.player2 = new ComputerPlayer("o", this.board);
    this.currentPlayer = this.player1;
  };

  Game.prototype.switchPlayers = function() {
    if (this.currentPlayer === this.player1) {
      this.currentPlayer = this.player2;
    } else {
      this.currentPlayer = this.player1;
    }
  };

  Game.prototype.play = function() {
    var that = this;
    this.board.show();

    this.currentPlayer.getMove(function() {
      if (that.board.won()) {
        that.board.show();
        console.log(that.board.winner() + " Wins!");
        HumanPlayer.READER.close();
      } else if (that.board.emptySpaces().length === 0) {
        that.board.show();
        console.log("Tie");
        HumanPlayer.READER.close();
      } else {
        that.switchPlayers();
        that.play();
      }
    });
  };

})(this);