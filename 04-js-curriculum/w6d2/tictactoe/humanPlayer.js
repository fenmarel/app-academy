(function(root) {
  var readline = require('readline');

  var TicTacToe = root.TicTacToe = (root.TicTacToe || {});
  var HumanPlayer = TicTacToe.HumanPlayer = function(mark, board) {
    this.mark = mark;
    this.board = board;
  }

  HumanPlayer.READER = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  HumanPlayer.prototype.getMove = function(callback) {
    var that = this;

    HumanPlayer.READER.question("Choose a move (0-8): ", function(pos) {
      if (that.board.empty(pos) && pos >= 0 && pos < 9) {
        that.board.placeMark(pos, that.mark);
        callback();
      } else {
        console.log("Invalid Move");
        that.getMove(callback);
      }
    });
  }

})(this);