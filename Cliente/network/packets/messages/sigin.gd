class_name SignInMessage extends RefCounted


var _client: WebSocketClient

var email: String
var password: String
var major: int
var minor: int
var revision: int


func _init(email: String = "", password: String = "", major: int = 0, minor: int = 0, revision: int = 0):
	self.email = email
	self.password = password
	self.major = major
	self.minor = minor
	self.revision = revision
	_client = Network.websocket


func from_packet(packet: Packet) -> SignInMessage:
	var packet_buff := StreamPeerBuffer.new()
	packet_buff.put_data(packet.content)
	packet_buff.seek(0)
	
	var email := packet_buff.get_string()
	var password := packet_buff.get_string()
	var major := packet_buff.get_u16()
	var minor := packet_buff.get_u16()
	var revision := packet_buff.get_u16()

	return SignInMessage.new(email, password, major, minor, revision)


func to_packet() -> Packet:
	var packet_buff := StreamPeerBuffer.new()
	packet_buff.put_utf8_string(email)
	packet_buff.put_utf8_string(password)
	packet_buff.put_u16(major)
	packet_buff.put_u16(minor)
	packet_buff.put_u16(revision)
	
	return Packet.new(ClientHeaders.list.sigin, packet_buff.data_array)


func send() -> void:
	print('x')
	_client.send_packet(self.to_packet())


func handle(packet: Packet, scene_tree: SceneTree) -> void:
	var sign_in_packet := from_packet(packet)
	print(sign_in_packet)
