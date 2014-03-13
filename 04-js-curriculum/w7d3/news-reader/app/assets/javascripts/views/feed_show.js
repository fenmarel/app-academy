;(function(root) {
  NewsReader.Views.FeedShow = Backbone.View.extend({

    initialize: function() {
      this.listenTo(this.model, "all", this.render);
    },

    template: JST['feeds/show'],

    events: {
      "click .refresh": "reload"
    },

    render: function() {
      this.$el.html(this.template({ feed: this.model }));
      return this;
    },

    reload: function() {
      this.model.fetch();
    }

  })
}(this));