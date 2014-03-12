Journal.Collections.Posts = Backbone.Collection.extend({

  model: Journal.Models.Post,
  url: '/posts'

});


Journal.Collections.posts = new Journal.Collections.Posts();