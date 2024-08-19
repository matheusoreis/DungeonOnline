class_name Packet extends RefCounted

var id: int = 0
var content: PackedByteArray


func from_packed_byte_array(data: PackedByteArray) -> Packet:
	var packet_buff := StreamPeerBuffer.new()
	packet_buff.data_array = data
	packet_buff.seek(0)

	var packet := Packet.new()

	packet.id = packet_buff.get_u16()

	var content_size = data.size() - packet_buff.get_position()

	if content_size > 0:
		packet.content = data.slice(packet_buff.get_position(), data.size())
	else:
		packet.content = PackedByteArray()

	return packet


func to_packet_byte_array() -> PackedByteArray:
	var buffer := StreamPeerBuffer.new()
	buffer.put_u16(id)
	buffer.put_data(content)

	return buffer.data_array


func to_strem_peer_buffer(packet: Packet) -> StreamPeerBuffer:
	var data := StreamPeerBuffer.new()
	data.data_array = packet.content
	return data
