Array.prototype.bubbleSort = function() {
  var sorted = false;

  while (!sorted) {
    sorted = true;

    for(var i = 0; i < this.length - 1; i++) {
      if (this[i] > this[i + 1]) {
        var temp = this[i];
        this[i] = this[i + 1];
        this[i + 1] = temp;

        sorted = false;
      }
    }
  }

  return this;
};

console.log([4, 2, 12, 6, 3, 0, -7].bubbleSort());


String.prototype.substrings = function() {
  var subs = [];

  for(var i = 0; i < this.length; i++) {
    for(var j = i + 1; j <= this.length; j++) {
      subs.push(this.slice(i, j));
    }
  }

  return subs;
};

console.log("cat".substrings());