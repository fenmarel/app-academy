// This is a manifest file that'll be compiled into application.js,
// which will include all the files listed below.
//
// Any JavaScript/Coffee file within this directory,
// lib/assets/javascripts, vendor/assets/javascripts, or
// vendor/assets/javascripts of plugins, if any, can be referenced
// here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll
// appear at the bottom of the the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE
// PROCESSED, ANY BLANK LINE SHOULD GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.serializeJSON
//= require underscore
//
//= require_tree ./models
//= require_tree ../templates
//
//= require_tree .
//= require_tree ./views


;(function(root){
  var PT = root.PT = (root.PT || {});

  PT.initialize = function() {
    PT.showPhotoIndex();
  }

  PT.showPhotoIndex = function(){
    PT.Photo.fetchByUserId(PT.CURRENT_USER_ID,function(){
      var listView = new PT.PhotosListView();
      $('div#content').html(listView.render().$el);
    });

    var formView = new PT.PhotoFormView();
    $('div#form').html(formView.render().$el);
  }

  PT.showPhotoDetail = function(photo){
    var detailView = new PT.PhotoDetailView(photo);
    $('div#content').html(detailView.render().$el);
  }
}(this));