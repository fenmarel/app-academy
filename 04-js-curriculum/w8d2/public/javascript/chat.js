(function(root){
	var ChatApp = root.ChatApp = (root.ChatApp || {});

	var Chat = ChatApp.Chat = function(username, room) {
		this.username = username;
		this.room = 'lobby';
	};

	Chat.prototype.sendMessage = function(message) {

		ChatApp.socket.emit('message', message);
	};

	$(function() {
		ChatApp.socket.on('newContent', function(content) {
			var $p = $('<p>');
			$p.text(content.username + ": " + content.message);
			$('#messages').append($p);
		});
	});

}(this));
