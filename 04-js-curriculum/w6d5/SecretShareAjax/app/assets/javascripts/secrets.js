$(document).ready(function() {
  $('#secret-form-container').on('submit', '#secret-form', function(event) {
    event.preventDefault();

    var $form = $(this);
    var formData = $form.serializeJSON();
    $('.tag-options select').remove();

    $.ajax({
      url: '/secrets.json',
      type: 'POST',
      data: formData,
      success: function(secret) {
        $('#secret-listing').prepend('<li>' + secret.title + '</li>');
        $('#secret-form input[type="text"]').val('');
      }
    })
  })
})