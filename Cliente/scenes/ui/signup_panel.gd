extends PanelContainer
#
#
#@export var username_edit : LineEdit
#@export var email_edit : LineEdit
#@export var password_edit : LineEdit
#@export var re_password_edit : LineEdit
#@export var signin_panel: PanelContainer
#
#
#var _signup_sender: SignUpSenderMessage
#var _client: Socket.PacketClient
#
#
#func _ready() -> void:
	#_signup_sender = SignUpSenderMessage.new()
	#_client = Network.async_socket
	#_client.endianness = Socket.Endianness.Little
#
#
#func _on_back_pressed() -> void:
	#self.hide()
	#signin_panel.show()
#
#
#func _on_create_pressed() -> void:
	#_signup_sender.send_data(_client, username_edit.text, email_edit.text, password_edit.text, re_password_edit.text)
