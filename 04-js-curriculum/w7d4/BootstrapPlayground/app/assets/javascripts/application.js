// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

$(document).ready(function() {

  $('#contact-btn').on("click", function(event) {
    event.preventDefault();
    $("#form-messages").html("<div class='alert alert-danger'>DANJA</div>");
  });

  $("#contact-form").on("keyup", ".contact-form", function(event) {
    if($(event.target).val()) {

      if($(event.target).parent().is("#contact-form-email")) {
        var emailCheck = /.+@.+\..+/i;
        if (emailCheck.test($(event.target).val())) {
          setInputClass($(event.target).parent(), "has-success has-feedback", "ok");
        } else {
          setInputClass($(event.target).parent(), "has-warning has-feedback", "warning-sign");
        }
      } else {
        setInputClass($(event.target).parent(), "has-success has-feedback", 'ok');
      }
    } else {
      setInputClass($(event.target).parent(), "has-error has-feedback", 'remove');
    }
  });

  var setInputClass = function(obj, endClass, glyph) {
    obj.removeClass("has-success has-warning has-error has-feedback");
    obj.addClass(endClass);
    obj.find('.glyphicon').remove();
    obj.append('<span class="glyphicon glyphicon-'+ glyph +' form-control-feedback" style="top:0px"></span>')
  }


  $('#consectetur').tooltip({ title: "this word is dumb"});

  $(document).scroll(function(event) {
    var $sidebar = $('#home-sidebar');
    var $text = $('#home-lorem-text');
    if (!$sidebar.length) {
      return
    }

    if (document.getElementById("home-sidebar").getBoundingClientRect().top < 100) {
      $sidebar.removeClass("affix-top");
      $sidebar.addClass("affix");
      $text.addClass("col-xs-offset-3")
    } else if ($sidebar.offset().top < 400){
      $sidebar.removeClass("affix");
      $sidebar.addClass("affix-top");
      $text.removeClass("col-xs-offset-3")
    }
  })

});