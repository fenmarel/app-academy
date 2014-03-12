Journal.Views.PostForm = Backbone.View.extend({
  initialize: function() {
    this.listenTo(this.model, "sync", this.render)
  },

  events: {
    "submit #new-post": "handlePost"
  },

  template: JST['posts/form'],

  render: function() {
    this.$el.empty()
    var form = this.template({post: this.model});
    this.$el.append(form);

    return this;
  },

  handlePost: function(event) {
    event.preventDefault();
    if (this.model.isNew()) {
      var postData = $(event.currentTarget).serializeJSON();
      var that = this;
      var post = new Journal.Models.Post(postData);

      post.save({}, {
        success: function() {
          that.$el.empty();
          Backbone.history.navigate('#/', {trigger: true});
        },
        error: function() {
          that.render();
        }
      });
    } else {
      var postData = $(event.currentTarget).serializeJSON();
      var that = this;
      this.model.save(postData, {
        success: function() {
          that.$el.empty();
          Backbone.history.navigate('#/', {trigger: true});
        },
        error: function(model, response) {
          that.$el.prepend('<h3>' + response.responseText)
        }
      })
    }
  }
});