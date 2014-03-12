Journal.Views.PostsIndex = Backbone.View.extend({
  tagName: "ul",

  initialize: function () {
    this.listenTo(this.collection, "remove add sync change reset", this.render);
  },

  template: JST['posts/index'],

  render: function() {
    this.$el.empty();
    var content = this.template({ posts: this.collection });

    this.$el.append(content);
    return this;
  },

  events: {
    "click .delete-post" : "removePost"
  },

  removePost: function(event, id) {
    var modelId = $(event.currentTarget).data('id')
    var model = this.collection.get(modelId);
    this.collection.remove(model);
    model.destroy();
  }
});