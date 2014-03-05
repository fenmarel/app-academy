(function(root) {
  var TicTacToe = root.TicTacToe = (root.TicTacToe || {});
  var Board = TicTacToe.Board = function() {
    this.grid = [NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN];
    this.winConditions = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                         [0, 3, 6], [1, 4, 7], [2, 5, 8],
                         [0, 4, 8], [2, 4, 6]];
  };

  Board.prototype.won = function() {
    for (var i = 0; i < this.winConditions.length; i++) {
      var condition0 = this.winConditions[i][0];
      var condition1 = this.winConditions[i][1];
      var condition2 = this.winConditions[i][2];

      if (this.grid[condition0] === this.grid[condition1] &&
          this.grid[condition0] === this.grid[condition2]) {

        this.winningPlayer = this.grid[condition0];
        return true;
      }
    }

    return false;
  };

  Board.prototype.winner = function() {
    return this.winningPlayer;
  };

  Board.prototype.empty = function(pos) {
    return !(this.grid[pos] === "x" || this.grid[pos] === "o");
  };

  Board.prototype.emptySpaces = function() {
    var empties = [];

    for (var i = 0; i < this.grid.length; i++) {
      if (this.empty(i)) {
        empties.push(i);
      }
    }

    return empties;
  };

  Board.prototype.placeMark = function(pos, mark) {
    if (this.empty(pos)) {
      this.grid[pos] = mark;
    } else {
      console.log("Invalid Move");
    }
  };

  Board.prototype.show = function() {
    var displayGrid = this.grid.map(function(x) { return (x !== x) ? "_" : x });

    console.log(displayGrid.slice(0,3));
    console.log(displayGrid.slice(3,6));
    console.log(displayGrid.slice(6,9));
    console.log();
  };

})(this);