class_name SignInSenderMessage


extends RefCounted


var _packets: ClientPackets


func _init() -> void:
	_packets = ClientPackets.new()


func send_data(client: Socket.PacketClient, email: String, password: String) -> void:
	var packet_buff := StreamPeerBuffer.new()

	packet_buff.put_32(_packets.list.signInRequest)
	packet_buff.put_utf8_string(email)
	packet_buff.put_utf8_string(password)

	var packet_data := packet_buff.data_array

	client.send_packet(packet_data)
