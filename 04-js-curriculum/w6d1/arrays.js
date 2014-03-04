Array.prototype.myUniq = function() {
  var uniq = [];

  for (var i = 0; i < this.length; i++) {
    if (uniq.indexOf(this[i]) === -1) {
      uniq.push(this[i])
    }
  }

  return uniq;
};

console.log([1, 2, 1, 3, 3].myUniq());


Array.prototype.twoSum = function() {
  var indices = [];

  for (var i = 0; i < this.length - 1; i++) {
    for (var j = i + 1; j < this.length; j++) {
      if (this[i] + this[j] === 0) {
        indices.push([i, j]);
      }
    }
  }

  return indices;
};

console.log([-1, 0, 2, -2, 1].twoSum());


Array.prototype.transpose = function() {
  var cols = [];
  var row = []

  for (var i = 0; i < this.length; i ++) {
    row = [];

    for (var j = 0; j < this[0].length; j++) {
      row.push(this[j][i]);
    }

    cols.push(row);
  }

  return cols;
};

var matrix = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8]
  ]
console.log(matrix.transpose());