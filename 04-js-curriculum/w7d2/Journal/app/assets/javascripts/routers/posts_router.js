Journal.Routers.Posts = Backbone.Router.extend({
  routes: {
    "" : "postIndex",
    "posts/new" : "createPost",
    "posts/:id" : "postShow",
    "posts/:id/edit" : "editPost"

  },

  postIndex: function() {
    var indexView = new Journal.Views.PostsIndex({
      collection: Journal.Collections.posts
    });

    Journal.Collections.posts.fetch();
    $('#sidebar').html(indexView.render().$el);
  },

  postShow: function(id) {
    var post = new Journal.Models.Post({id: id});
    var showView = new Journal.Views.PostsShow({
      model: post
    })
    post.fetch();
    this._swapView(showView);
  },

  createPost: function() {
    var post = new Journal.Models.Post();
    var postForm = new Journal.Views.PostForm({
      model: post
    })

    this._swapView(postForm);
  },

  editPost: function(id) {
    var post = new Journal.Models.Post({id: id});
    post.fetch();

    var postForm = new Journal.Views.PostForm({
      model: post
    })


    this._swapView(postForm);
  },

  _swapView: function (view) {
      if (this.currentView) {
        this.currentView.remove();
      }
      this.currentView = view;

      $("#content").html(view.render().$el);
    }
});
