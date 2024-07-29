class_name PingSenderMessage


extends RefCounted


var _packets: ClientPackets


func _init() -> void:
	_packets = ClientPackets.new()


func send_data(client: Socket.PacketClient) -> void:
	var packet_buff := StreamPeerBuffer.new()

	packet_buff.put_32(_packets.list.pingRequest)
	var packet_data := packet_buff.data_array

	Globals.send_ping_time = Time.get_unix_time_from_system()

	client.send_packet(packet_data)
