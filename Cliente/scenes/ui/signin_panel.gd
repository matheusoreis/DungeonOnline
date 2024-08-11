extends PanelContainer
#
#
#@export var email_edit : LineEdit
#@export var password_edit : LineEdit
#@export var signup_panel: PanelContainer
#
#var _signin_sender: SignInSenderMessage
#var _client: Socket.PacketClient
#
#
#func _ready() -> void:
	#_signin_sender = SignInSenderMessage.new()
	#_client = Network.async_socket
	#_client.endianness = Socket.Endianness.Little
#
#
#func _on_access_pressed() -> void:
	#_signin_sender.send_data(_client, email_edit.text, password_edit.text)
#
#
#func _on_create_pressed() -> void:
	#signup_panel.show()
	#self.hide()
