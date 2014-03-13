;(function(root){

  NewsReader.Collections.Entries = Backbone.Collection.extend({
    model: NewsReader.Models.Entry,

    comparator: function(model) {
      return -Date.parse(model.get('json').pubDate);
    }
  });

})(this);