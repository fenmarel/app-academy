var game = new TTT.Game();


$(document).ready(function() {
  $('.container div').click(function() {
    var coord = $(this).data('coord');
    var mark = game.player;

    if (game.move(coord)) {
      $(this).html(mark);

      if (game.winner()) {
        alert(game.winner() + " is the winner!");
        location.reload();
      } else if (game.isBoardFilled()) {
        alert("Tie! Let's play again.");
        location.reload();
      }
    };
  });
});