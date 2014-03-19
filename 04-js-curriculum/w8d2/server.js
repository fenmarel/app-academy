var app = require('http').createServer(handler),
		file = require('./lib/router').fileServer,
		io = require('socket.io'),
		createSocket = require('./lib/chat_server').createSocket(app);

app.listen(8080);


function handler(request, response) {
  request.addListener('end', function () {

		console.log("hello");
    file.serve(request, response, function(err, res) {
			if ( err && (err.status === 404)) {
				console.log('have err');
				file.serveFile('/not-found.html', 404, {}, request, response);
			}
		});
	}).resume();
};


