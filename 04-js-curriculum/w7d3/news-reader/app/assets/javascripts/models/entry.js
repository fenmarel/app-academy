;(function(root){

  NewsReader.Models.Entry = Backbone.Model.extend({
    initialize: function() {
      this.attributes.json = JSON.parse(this.attributes.json);
    }
  });

})(this);