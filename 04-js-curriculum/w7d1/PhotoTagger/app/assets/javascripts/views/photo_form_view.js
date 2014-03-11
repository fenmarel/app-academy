;(function(root){
  var PT = root.PT = (root.PT || {});

  var PhotoFormView = PT.PhotoFormView = function() {
    this.$el = $('<div>');
    this.$el.on("submit","#photo-form-template", this.submit.bind(this));
  }

  _.extend(PhotoFormView.prototype, {
    render: function() {
      var templateFn = JST['photo_form'];
      var rendered = templateFn();

      this.$el.html(rendered);
      return this;
    },

    submit: function(event){
      event.preventDefault();
      var params = $(event.target).serializeJSON();
      var photo = new PT.Photo(params["photo"]);
      $($(event.target).find('input[type=text]').not(':hidden')).val('');
      photo.create(function(){});
    }
  })
}(this));