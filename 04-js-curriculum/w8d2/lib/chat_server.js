var io = require('socket.io');

function createSocket(app) {
  io = io.listen(app);
  var currentRooms = {'lobby': []};
  var userId = 1;
  var users = [];

  io.sockets.on('connection', function (socket) {
    var userName = "Guest" + userId;
    users.push(userName);
    joinRoom(undefined, 'lobby', userName);

    socket.emit('createUser', {username: userName, room: "lobby"});

    userId++;

    function processCommand (message) {
      if (/^\/nick /.test(message.message) && !(/\s(Guest|SERVER)/i.test(message.message))) {
        var currentRoom = currentRooms[message.room];

        currentRoom.splice(currentRoom.indexOf(message.username));
        var username = message.message.slice(6);

        currentRoom.push(username);
        var info = message.username + " changed their name to " + username;

        socket.emit("newName", {username: username, info: info, room: message.room});
      } else if (/^\/join /.test(message.message)) {
        var roomname = message.message.slice(6);
        joinRoom(message.room, roomname, message.username);
      }
    };


    function joinRoom(oldroom, newroom, username) {
      var currentRoom = currentRooms[newroom] || (currentRooms[newroom] = []);
      currentRoom.push(username);
      if ( oldroom ) {
        currentRooms[oldroom].splice(currentRooms[oldroom].indexOf(username));
        socket.leave(oldroom);
      }
      socket.join(newroom);
      socket.emit('changedRoom', {room: newroom, userlist: currentRoom});
    };

    socket.on("message", function(message) {

      if (/^\//.test(message.message)) {
        processCommand(message);
      } else {
        io.sockets.in(message.room).emit("newContent", message);
      }
    });
  });
}

exports.createSocket = createSocket;

