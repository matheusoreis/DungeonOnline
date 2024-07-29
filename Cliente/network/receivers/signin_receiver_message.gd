class_name SignInReceiverMessage

extends RefCounted

var _use_character_sender_message: UserCharacterSenderMessage

func receiver(scene_tree: SceneTree, buffer: StreamPeerBuffer) -> void:
	_use_character_sender_message = UserCharacterSenderMessage.new()
	var _client = Network.async_socket

	var signin_panel := scene_tree.root.get_node('/root/main/SignInPanel') as PanelContainer
	var signup_panel := scene_tree.root.get_node('/root/main/SignUpPanel') as PanelContainer
	var create_character_panel := scene_tree.root.get_node('/root/main/CreateCharacterPanel') as PanelContainer

	if buffer.get_8() > 0:
		var character_id = buffer.get_32()
		_use_character_sender_message.send_data(_client, character_id)
	else:
		create_character_panel.show()

	signin_panel.hide()
	signup_panel.hide()
