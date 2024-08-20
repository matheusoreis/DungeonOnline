class_name SignInMessage extends RefCounted


var _client: WebSocketClient

var email: String
var password: String


func _init():
    _client = Network.websocket


func from_packet(_packet: Packet) -> SignInMessage:
    var sign_in = SignInMessage.new()
    sign_in.email = ''
    sign_in.password = ''

    return sign_in


func to_packet() -> Packet:
    var constants := Constants.new()
    var packet_buff := StreamPeerBuffer.new()
    packet_buff.put_utf8_string(email)
    packet_buff.put_utf8_string(password)
    packet_buff.put_u16(constants.major_version)
    packet_buff.put_u16(constants.minor_version)
    packet_buff.put_u16(constants.revision_version)

    var packet := Packet.new()
    packet.id = ClientHeaders.list.sigin
    packet.content = packet_buff.data_array

    return packet


func send() -> void:
    _client.send_packet(self.to_packet())


func handle(packet: Packet, scene_tree: SceneTree) -> void:
    #var sign_in_packet := from_packet(packet)
    pass
