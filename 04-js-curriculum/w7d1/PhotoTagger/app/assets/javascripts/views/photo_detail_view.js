;(function(root){
  var PT = root.PT = (root.PT || {});

  var PhotoDetailView = PT.PhotoDetailView = function(photo) {
    this.photo = photo;
    this.$el = $('<div>');
    this.$el.on("click", "#back-home", PT.showPhotoIndex);
    this.$el.on("click", "#current-photo", this.popTagSelectView.bind(this))
    this.tagView;
  };

  _.extend(PhotoDetailView.prototype,{
    render: function(){
      var renderFn = JST["photo_detail"];
      var rendered = renderFn({ photo: this.photo });
      this.$el.html(rendered);
      return this;
    },

    popTagSelectView: function(event){
      if (this.tagView) {
        this.tagView.$el.remove();
      }
      this.tagView = new PT.TagSelectView(this.photo, event);
      $('div#content').append(this.tagView.render().$el);
    }
  });
}(this));