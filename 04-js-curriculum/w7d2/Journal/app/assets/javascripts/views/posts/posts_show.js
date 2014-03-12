Journal.Views.PostsShow = Backbone.View.extend({
  initialize: function(){
    this.listenTo(this.model, "sync", this.render);
    //this.listenTo(this.model, "dblclick #title", this.editText);
  },

  template: JST['/posts/show'],

  events: {
    "dblclick .title" : "editTitle",
    "dblclick .body" : "editBody",
    "blur .editbox" : "quickEdit"
  },

  render: function() {
    this.$el.empty();
    var title = this.model.get('title');
    var body = this.model.get('body');
    this.$el.append('<h1 class=\"title\">' + title).append('<p class=\"body\">' + body);
    return this;
  },

  editTitle: function(event) {
    var currentText =  $(event.currentTarget).text();
    var $editBox = $('<input data-type="title" class=\"editbox\" type=\"text\" value='+ currentText +'>');
    $(event.currentTarget).html($editBox);
  },

  editBody: function(event) {
    var currentText =  $(event.currentTarget).text();
    var $editBox = $('<input data-type="body" class=\"editbox\" type=\"text\" value='+ currentText +'>');
    $(event.currentTarget).html($editBox);
  },

  quickEdit: function(event) {
    var type = $(event.target).data('type');
    var val = $(event.target).val();
    this.model.set(type, val);
    this.model.save();
    Journal.Collections.posts.add(this.model, { merge: true });
  }
});