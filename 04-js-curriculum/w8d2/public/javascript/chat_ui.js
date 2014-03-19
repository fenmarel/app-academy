(function(root) {
	root.ChatApp.socket = io.connect();

	var chat = new ChatApp.Chat("test", "lobby");
	var username = 'default';

	$(function(){
		$('#chat-submit').on('click', function(event) {
			event.preventDefault();
			var message = $('#chat-input').val();
			chat.sendMessage({message: message, username: chat.username, room: chat.room });
			$('#chat-input').val('').focus();
		});

		ChatApp.socket.on("newName", function(options) {
			chat.username = options.username;
			ChatApp.socket.emit('message', {username: 'SERVER',
																		  message: options.info,
																			room: options.room
																			});
		});

		ChatApp.socket.on("createUser", function(options) {
			chat.username = options.username;

			ChatApp.socket.emit('message', {username: 'SERVER',
				 															message: options.username + ' joined the fun',
																			room: options.room
																			});
		});

		ChatApp.socket.on("changedRoom", function(options){
			console.log("changed room");
			chat.room = options.room;

			ChatApp.socket.emit('message', {username: 'SERVER',
				 															message: chat.username + ' joined ' + options.room,
																			room: options.room
																		});

			$('#roomList').empty();
			options.userlist.forEach(function(user) {
				$('#roomList').append("<p>" + user + "</p>")
			});
		})
	});

}(this));