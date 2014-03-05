Function.prototype.myBind = function(bound) {
  var that = this;

  return function() {
    return that.apply(bound);
  };
};