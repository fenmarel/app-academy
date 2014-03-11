;(function(root){
  var PT = root.PT = (root.PT || {});

  var TagSelectView = PT.TagSelectView = function(photo, clickEvent) {
    this.photo = photo;
    this.clickEvent = clickEvent;
    this.$el = $('<div>');
    this.$el.on('click', '.tag-options li', this.addTagging.bind(this));
  };

  _.extend(TagSelectView.prototype, {
    render: function() {
      var $img = $(this.clickEvent.target);
      var imgPosition = $img.position();
      var position = [imgPosition["left"] + this.clickEvent.offsetX,
                      imgPosition["top"] + this.clickEvent.offsetY];
      this.$el.addClass("photo-tag");
      this.$el.css("position", "absolute");
      this.$el.css("left", position[0] - 50);
      this.$el.css("top", position[1] - 50);
      var renderFn = JST["photo_tag_options"];
      var rendered = renderFn();

      this.$el.append(rendered);

      return this;
    },

    addTagging: function(event) {
      var userId = $(event.target).data("id");
      var xPos = this.clickEvent.offsetX
      var yPos = this.clickEvent.offsetY
      var photoId = this.photo.get("id")
      var tagging = new PT.PhotoTagging({
        user_id: userId,
        x_pos: xPos,
        y_pos: yPos,
        photo_id: photoId
      })
      tagging.create(function(){});
      this.$el.remove();
    }
  });

}(this));