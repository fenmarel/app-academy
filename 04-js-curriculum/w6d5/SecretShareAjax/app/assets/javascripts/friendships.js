$(document).ready(function() {
  var toggleFriendButtons = function($currentButton) {
    $currentButton.parent('#follow-buttons').toggleClass('can-follow');
    $currentButton.parent('#follow-buttons').toggleClass('can-unfollow');
  }


  $('#user-list').on('click', '.follow', function(event) {
    event.preventDefault();

    var $button = $(this);
    var formData = $button.data();
    $button.attr('disabled', 'disabled');
    $button.html('Following...');

    $.ajax({
      url: '/users/' + formData.user_id + '/friendship.json',
      type: 'POST',
      data: formData,
      success: function() {
        toggleFriendButtons($button);

        $button.siblings('.un-follow').removeAttr('disabled');
        $button.siblings('.un-follow').html('Un-Follow');
      }
    });
  });

  $('#user-list').on('click', '.un-follow', function(event) {
    event.preventDefault();

    var $button = $(this);
    var formData = $button.data();
    $button.attr('disabled', 'disabled');
    $button.html('Un-Following...');

    $.ajax({
      url: '/users/' + formData.user_id + '/friendship.json',
      type: 'DELETE',
      data: formData,
      success: function() {
        toggleFriendButtons($button);

        $button.siblings('.follow').removeAttr('disabled');
        $button.siblings('.follow').html('Follow');
      }
    })
  })
});