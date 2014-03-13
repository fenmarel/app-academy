window.NewsReader = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    // NewsReader.feeds = new NewsReader.Collections.Feeds();
    NewsReader.feeds = new NewsReader.Collections.Feeds(JSON.parse($('#boot').text()));
    // NewsReader.feeds.fetch({
    //   success: function(){
        new NewsReader.Routers.newsReaderRouter($('#content'), $('#entry'));
        Backbone.history.start();
      // }
    // });
  }
};

$(document).ready(function(){
  NewsReader.initialize();
});
