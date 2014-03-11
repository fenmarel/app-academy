(function(root) {
  var PT = root.PT = (root.PT || {});

  var Photo = PT.Photo = function(options) {
    this.attributes = _.extend({}, options);
  };

  Photo.all = [];
  Photo._events = {};

  Photo.on = function(eventName, callback){
    if (!Photo._events[eventName]) {
      Photo._events[eventName] = [];
    }
    Photo._events[eventName].push(callback);
  };

  Photo.trigger = function(eventName) {
    if (Photo._events[eventName]) {
      Photo._events[eventName].forEach(function(event) {
        event();
      })
    }
  };

  Photo.find = function(id, callback) {
    $.ajax({
      url: '/api/photos/' + id,
      type: 'GET',
      success: function(item) {
        var photo = new Photo(item);
        callback(photo);
      }
    })
  };

  Photo.fetchByUserId = function(userId, callback){
    $.ajax({
      url: '/api/users/' + userId + '/photos',
      type: 'GET',
      success: function(items) {
        var fetched = [];
        items.forEach(function(item) {
           fetched.push(new PT.Photo(item))
        });
        // fetched.forEach(function(photo){
        //   var exists = _.some(Photo.all, function(existing){
        //     return existing.id === photo.id;
        //   });
        //   if (!exists) { Photo.all.push(photo) }
        // });
        Photo.all = fetched
        return callback(fetched);
      },
      error: function(items) {
        alert(items);
      }
    });
  };




  _.extend(Photo.prototype, {

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
          url: '/api/photos',
          type: 'POST',
          data: { 'photo': this.attributes },
          success: function(item) {
            var photo = new Photo(item);
            _.extend(that.attributes, photo.attributes);
            Photo.all.unshift(photo);
            callback(photo);
            Photo.trigger("add");
          },
          error: function(item) {
            alert(item);
          }
        });
      }
    },

    save: function(callback) {
      if (this.attributes.id){
        var that = this;

        $.ajax({
          url: '/api/photos/'+ this.attributes.id ,
          type: 'PATCH',
          data: { 'photo': this.attributes },
          success: function(item) {
            var photo = new Photo(item);
            _.extend(that.attributes, photo.attributes);
            callback(photo);
          },
          error: function(item) {
            alert(item);
          }
        });
      } else {
        this.create(callback);
      }
    },

  })




})(this);