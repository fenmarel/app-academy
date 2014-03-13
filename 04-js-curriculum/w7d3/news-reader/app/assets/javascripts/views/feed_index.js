;(function(root) {
  NewsReader.Views.FeedIndex = Backbone.View.extend({
    initialize: function() {
      this.listenTo(this.collection, "all", this.render);
    },

    template: JST['feeds/index'],

    events: {
      "click .new-feed": "newFeed",
      "submit #new-form": "create"
    },

    render: function() {
      this.$el.html(this.template({ feeds: this.collection }));
      return this;
    },

    newFeed: function() {
      var formTemplate = JST['feeds/form'];
      this.$el.append(formTemplate());
    },

    create: function(event) {
      event.preventDefault();
      var formData = $(event.target).serializeJSON();
      var that = this;

      $.ajax({
        url: '/feeds',
        type: 'POST',
        data: formData,
        success: function(feed) {
          that.collection.add(feed);
        }
      })
    }
  })
}(this));