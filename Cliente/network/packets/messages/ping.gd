class_name PingMessage extends RefCounted


var _client: WebSocketClient
var _sender_ping_time: float


func _init():
	_client = Network.websocket


func from_packet(_packet: Packet) -> PingMessage:
	return self


func to_packet() -> Packet:
	return Packet.new(ClientHeaders.list.ping, PackedByteArray())


func send() -> void:
	_sender_ping_time = Time.get_unix_time_from_system()
	_client.send_packet(self.to_packet())


func handle(_packet: Packet, scene_tree: SceneTree) -> void:
	var receiver_time := Time.get_unix_time_from_system()
	var latency = round(_sender_ping_time - receiver_time)

	var ping_label_location := '/root/main/Canvas/PingLabel'
	var ping_label := scene_tree.root.get_node(ping_label_location) as Label

	if latency >= 0 and latency <= 5:
		ping_label.text = 'Local'
	else:
		ping_label.text = str(latency) + 'ms'
