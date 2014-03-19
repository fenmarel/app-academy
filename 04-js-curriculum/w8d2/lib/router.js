var static = require('node-static');
var fileServer = new static.Server('./public');

exports.fileServer = fileServer;

