;(function(root){

  NewsReader.Collections.Feeds = Backbone.Collection.extend({
    url: '/feeds',
    model: NewsReader.Models.Feed,

    getOrFetch: function(id, callback) {
      var model;
      var feeds = this;
      if (model = this.get(id)) {
        model.fetch({
          success: function() {
            callback && callback(model);
          }
        });
      } else {
        model = new NewsReader.Models.Feed({ id: id });
        model.fetch({
          success: function() {
            feeds.add(model);
            callback && callback(model);
          }
        });
      }
      return model;
    }
  });

})(this);