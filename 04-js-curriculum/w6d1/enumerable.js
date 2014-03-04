Array.prototype.multiplyByTwo = function() {
  var newArr = [];

  for (var i = 0; i < this.length; i++) {
    newArr.push(this[i] * 2)
  }

  return newArr;
};

console.log([1, 2, 3].multiplyByTwo());


Array.prototype.myEach = function(func) {
  for (var i = 0; i < this.length; i++) {
    func(this[i]);
  }
};

[1, 2, 3].myEach( function(x) { console.log(x) })


Array.prototype.myMap = function(func) {
  var newArr = [];

  this.myEach(function(x) {
    newArr.push(func(x));
  });

  return newArr;
}

console.log([1, 2, 3].myMap(function(x) {
  return x * 3;
}));


Array.prototype.myInject = function(func) {
  var acc = this[0];

  this.slice(1, this.length).myEach(function(x) {
    acc = func(acc, x);
  });

  return acc;
};

console.log([1, 2, 3, 4].myInject(function(acc, x) {
  return acc + x;
}));


