$(document).ready(function() {
  $('#user-list').on('click', '.follow', function(event) {
    event.preventDefault();

    var $button = $(this)
    var formData = $button.data()
    $button.attr('disabled', 'disabled');
    $button.html('Following...');

    $.ajax({
      url: "/users/" + formData.user_id + "/friendships.json",
      type: 'POST',
      data: formData,
      success: function() {
        $button.remove();
      }
    });
  })
});