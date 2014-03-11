;(function(root){
  var PT = root.PT = (root.PT || {});

  var PhotoTagging = PT.PhotoTagging = function(options) {
    this.attributes = _.extend({}, options);
  };

  PhotoTagging.all = [];
  PhotoTagging._events = {};

  PhotoTagging.on = function(eventName, callback){
    if (!PhotoTagging._events[eventName]) {
      PhotoTagging._events[eventName] = [];
    }
    PhotoTagging._events[eventName].push(callback);
  };

  PhotoTagging.trigger = function(eventName) {
    if (PhotoTagging._events[eventName]) {
      PhotoTagging._events[eventName].forEach(function(event) {
        event();
      })
    }
  };

  // PhotoTagging.find = function(id, callback) {
  //   $.ajax({
  //     url: '/api/photos/' + id,
  //     type: 'GET',
  //     success: function(item) {
  //       var photo = new PhotoTagging(item);
  //       callback(photo);
  //     }
  //   })
  // };

  PhotoTagging.fetchByPhotoId = function(photoId, callback){
    $.ajax({
      url: '/api/photos/' + photoId + '/photo_taggings',
      type: 'GET',
      success: function(items) {
        var fetched = [];
        items.forEach(function(item) {
           fetched.push(new PT.PhotoTagging(item))
        });
        // fetched.forEach(function(photo){
        //   var exists = _.some(PhotoTagging.all, function(existing){
        //     return existing.id === photo.id;
        //   });
        //   if (!exists) { PhotoTagging.all.push(photo) }
        // });
        PhotoTagging.all = fetched
        return callback(fetched);
      },
      error: function(items) {
        alert(items);
      }
    });
  };




  _.extend(PhotoTagging.prototype, {

    get: function(attr_name) {
      return this.attributes[attr_name];
    },

    set: function(attr_name, val) {
      this.attributes[attr_name] = val;
    },

    create: function(callback) {
      if (this.attributes.id) {
        // something else
        return;
      } else {
        var that = this;

        $.ajax({
          url: '/api/photo_taggings',
          type: 'POST',
          data: { 'photo_tagging': this.attributes },
          success: function(item) {
            var photo = new PhotoTagging(item);
            _.extend(that.attributes, photo.attributes);
            PhotoTagging.all.push(photo);
            callback(photo);
            PhotoTagging.trigger("add");
          },
          error: function(item) {
            alert("Tag Already Created!");
          }
        });
      }
    },

    // save: function(callback) {
    //   if (this.attributes.id){
    //     var that = this;
    //
    //     $.ajax({
    //       url: '/api/photo_taggings/'+ this.attributes.id ,
    //       type: 'PATCH',
    //       data: { 'photo': this.attributes },
    //       success: function(item) {
    //         var photo = new PhotoTagging(item);
    //         _.extend(that.attributes, photo.attributes);
    //         callback(photo);
    //       },
    //       error: function(item) {
    //         alert(item);
    //       }
    //     });
    //   } else {
    //     this.create(callback);
    //   }
    // },

  })


}(this));