;(function(root) {
  NewsReader.Views.EntryShow = Backbone.View.extend({
    initialize: function(options) {
      this.feed = options.feed;

      this.listenTo(this.model, "all", this.render);
    },

    events: {
      'click .close-modal': 'close'
    },

    template: JST['entries/show'],

    render: function() {
      json = this.model.get('json');
      this.$el.html(this.template({ entry: json, feed: this.feed }));

      return this;
    },

    close: function() {
      Backbone.history.navigate('#/feeds/'+this.feed.id);
    }
  })
}(this));