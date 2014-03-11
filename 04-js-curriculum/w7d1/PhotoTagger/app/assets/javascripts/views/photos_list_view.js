;(function(root){
  var PT = root.PT = (root.PT || {});
  var PhotosListView = PT.PhotosListView = function(){
    this.$el = $('<div>');
    PT.Photo.on("add", this.render.bind(this));
    this.$el.on("click", "a", this.showDetail)
  }

  _.extend(PhotosListView.prototype,{
    render: function(){
      this.$el.html('<ul></ul>');
      var that = this;
      PT.Photo.all.forEach(function(photo){
        that.$el.append('<li><a href ="#" data-id="'+ photo.get('id') + '">' + photo.get('title') + '</a></li>'
        );

      });

      return this;
    },

    showDetail: function(event){
      event.preventDefault();
      console.log(event);
      PT.Photo.find($(event.target).data('id'), PT.showPhotoDetail);
    }
  })



}(this));