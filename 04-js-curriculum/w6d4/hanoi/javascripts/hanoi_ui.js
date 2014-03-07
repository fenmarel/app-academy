(function(root) {
  var Hanoi = root.Hanoi = (root.Hanoi || {});
  var View = Hanoi.View = function($docElem) {
    this.docElem = $docElem;
  }

  View.prototype.updateDisplay = function() {
    $('.disk').remove();
    for (var t = 0; t < game.towers.length; t++) {
      for (var d = 0; d < game.towers[t].length; d++) {
        var $addTo = $('.tower:nth-child('+(t+1)+')');
        $addTo.append('<div class="disk">' + game.towers[t][d] + "</div>");
      }
    }
  };

  View.prototype.run = function() {
    var that = this;

    $(document).ready(function() {
      var fromTower;
      var toTower;
      that.updateDisplay();

      $('.tower').click(function() {
        if (toTower === undefined) {
          toTower = parseInt($(this).data('tower'));
        } else {
          fromTower = parseInt($(this).data('tower'));

          game.move(toTower, fromTower);
          toTower = undefined;
          that.updateDisplay();

          if (game.isWon()) {
            alert("You WIN!");
            location.reload();
          }
        }
      });
    });
  };

})(this);

var game = new Hanoi.Game();
var view = new Hanoi.View();
view.run();


