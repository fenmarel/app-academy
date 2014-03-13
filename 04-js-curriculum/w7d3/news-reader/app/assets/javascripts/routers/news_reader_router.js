;(function(root) {
  NewsReader.Routers.newsReaderRouter = Backbone.Router.extend({
    initialize: function($rootEl, $modalEl) {
      this.$rootEl = $rootEl;
      this.$modalEl = $modalEl;
    },

    routes: {
      "": "feedIndex",
      "feeds": "feedIndex",
      "feeds/:id": "feedShow",
      "feeds/:feed_id/entries/:id": "entryShow"
    },

    feedIndex: function() {
      this._swapView(new NewsReader.Views.FeedIndex({
        collection: NewsReader.feeds
      }));
    },

    feedShow: function(id) {
      var that = this;
      NewsReader.feeds.getOrFetch(id, function(model) {
        that._swapView(new NewsReader.Views.FeedShow({ model: model }));
      });
    },

    entryShow: function(feed_id, id) {
      var that = this;
      NewsReader.feeds.getOrFetch(feed_id, function(m) {
        var entry = m.entries.get(parseInt(id));
        that._swapView(new NewsReader.Views.FeedShow({ model: m }));
        that._modal(new NewsReader.Views.EntryShow({ model: entry, feed: m }));
      });
    },

    _swapView: function(newView) {
      this._currentView && this._currentView.remove();
      this._currentView = newView;
      var el = newView.render().$el;
      this.$rootEl.html(el);
    },

    _modal: function(view) {
      this._modalView && this._modalView.remove();
      this._modalView = view;
      var el = view.render().$el;
      this.$modalEl.html(el);
      this.$modalEl.modal('show');
    }

  });
}(this));