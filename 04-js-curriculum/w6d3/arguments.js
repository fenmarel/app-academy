var sum = function() {
  var args = [].slice.call(arguments);
  var sum = 0;

  args.forEach(function(x) {
    sum += x;
  });

  return sum;
};

console.log(sum(1, 2, 3, 4));


Function.prototype.myBind = function(obj) {
  var args = [].slice.call(arguments, 1, arguments.length);
  var that = this;

  return function() {
    var innerArgs = [].slice.call(arguments);
    return that.apply(obj, args.concat(innerArgs));
  }
};

// Testing myBind
function Cat() {
  this.name = "cat";
}

// anonymous function for saying cat name and adding some numbers
function sayNameAndAdd(n1, n2, n3) {
  console.log(this.name);
  return (n1 + n2 + n3);
}

// initialize a cat instance
var cat = new Cat();

// create the bound function with one argument
var boundSayNameAndAdd = sayNameAndAdd.bind(cat, 1);

// call the bound version with two new arguments
// it should add the arguments passed to bind AND those passed in here
console.log(boundSayNameAndAdd(2, 3));


var curriedSum = function(n) {
  var i = 0,
      sum = 0;
  var _curriedSum = function(num){
    i++;
    if (i < n){
      sum += num;
      return _curriedSum;
    }
    sum += num;
    return sum;
  };
  return _curriedSum;
};

var sum = curriedSum(4);
console.log(sum(5)(30)(20)(1));


var curryCollectAndSum = function(numArgs){
  var numbers = [];

  var _curryCollectAndSum = function(num){
    numbers.push(num);
    if (numbers.length < numArgs) {
      return _curryCollectAndSum;
    } else {
      var sum = 0;
      numbers.forEach(function(x) {
        sum += x;
      });
      return sum;
    }
  }
  return _curryCollectAndSum;
};

var sum = curryCollectAndSum(4);
console.log(sum(5)(30)(20)(2));

