$(document).ready(function() {
  var templateCode = $('#tag-options-template').html();
  var templateFn = _.template(templateCode);
  var content = templateFn({});

  $('.tag-form').on('click', '#add-tag-options', function(event) {
    event.preventDefault();
     $('span.tag-options').append(content);
  })
});