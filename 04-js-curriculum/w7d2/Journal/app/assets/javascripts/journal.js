window.Journal = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: $(function() {
    var router = new Journal.Routers.Posts();
    router.postIndex()
    Backbone.history.start();
  })
};
