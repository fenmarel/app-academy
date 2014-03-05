(function(root) {
  var readline = require('readline');

  var READER = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  var Hanoi = root.Hanoi = (root.Hanoi || {});

  var Game = Hanoi.Game = function() {
    this.towers = [ [3, 2, 1], [], [] ];
  };

  Game.prototype.move = function(startTower, destTower) {
    if (this.validMove(startTower, destTower)) {
      movedDisc = this.towers[+startTower].pop();
      this.towers[+destTower].push(movedDisc);
    } else {
      console.log("Invalid Move");
    }
  };

  Game.prototype.validMove = function(startTower, destTower) {
    if (this.towers[+startTower].length === 0 ||
         (this.towers[+startTower][this.towers[+startTower].length - 1] >
         this.towers[+destTower][this.towers[+destTower].length - 1]) ||
         [0, 1, 2].indexOf(+startTower) === -1 ||
         [0, 1, 2].indexOf(+destTower) === -1) {
      return false;
    }
    return true;
  };

  Game.prototype.won = function() {
    return this.towers[1].toString() == [3, 2, 1].toString() ||
    this.towers[2].toString() == [3, 2, 1].toString();
  };

  Game.prototype.play = function() {
    console.log("Welcome to Towers of Hanoi!");
    console.log(this.towers);

    this.getMove();
  };

  Game.prototype.getMove = function() {
    var that = this;
    READER.question("Select starting tower(0, 1, or 2)", function(starting) {
      READER.question("Select destination tower(0, 1, or 2)", function(ending) {
        that.move(starting, ending);

        if (that.won()) {
          console.log();
          console.log(that.towers);
          console.log("You WIN!");
          READER.close();
        } else {
          console.log();
          console.log(that.towers);
          that.getMove();
        }
      });
    });
  };

})(this);