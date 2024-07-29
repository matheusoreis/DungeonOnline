class_name SignUpSenderMessage


extends RefCounted


var _packets: ClientPackets


func _init() -> void:
	_packets = ClientPackets.new()


func send_data(client: Socket.PacketClient, username: String, email: String, password: String, re_password: String) -> void:
	var packet_buff := StreamPeerBuffer.new()

	packet_buff.put_32(_packets.list.signUpRequest)
	packet_buff.put_utf8_string(username)
	packet_buff.put_utf8_string(email)
	packet_buff.put_utf8_string(password)
	packet_buff.put_utf8_string(re_password)

	var packet_data := packet_buff.data_array

	client.send_packet(packet_data)
