class_name AlertMessage extends RefCounted


var _client: WebSocketClient
var message: String


func _init():
	_client = Network.websocket


func from_packet(packet: Packet) -> AlertMessage:
	var alert = AlertMessage.new()
	var buffer := packet.to_strem_peer_buffer(packet)
	alert.message = buffer.get_utf8_string()

	if buffer.get_8() == 1:
		_client.disconnect_from_host()

	return alert


func to_packet() -> Packet:
	var packet := Packet.new()
	packet.id = ClientHeaders.list.ping
	packet.content = PackedByteArray()

	return packet


func send() -> void:
	_client.send_packet(self.to_packet())


func handle(packet: Packet, scene_tree: SceneTree) -> void:
	var alert_scene := preload("res://scenes/ui/alert/alert_ui.tscn") as PackedScene
	var alert_panel := alert_scene.instantiate() as AlertUI
	var alert_panel_location := '/root/main/Shared/AlertPanel/AlertsVBox'
	var alert_vbox := scene_tree.root.get_node(alert_panel_location) as VBoxContainer

	var data := from_packet(packet)

	alert_panel.message.text = data.message
	alert_vbox.add_child(alert_panel)
