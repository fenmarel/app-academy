
Function.prototype.inherits = function(obj){
  function S() {};
  S.prototype = obj.prototype;

  this.prototype = new S();
}