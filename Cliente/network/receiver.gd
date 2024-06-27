class_name Receiver


extends RefCounted


var _packets: ServerPackets
var _receiver_message_handlers: Array = []
var _scene_tree: SceneTree


func _init(scene_tree: SceneTree) -> void:
	_packets = ServerPackets.new()
	_scene_tree = scene_tree
	
	for element in range(_packets.list.count):
		_receiver_message_handlers.append(null)
	
	_receiver_message_handlers[_packets.list.ping] = PingReceiverMessage.new()

func receiver_data(data: PackedByteArray) -> void:
	var buffer := StreamPeerBuffer.new()
	
	buffer.data_array = data

	var packet_id := buffer.get_32()
	var handler = _receiver_message_handlers[packet_id]
	
	if handler != null:
		handler.receiver(_scene_tree, buffer)
	else:
		print('No handler found for packet ID:', packet_id)
