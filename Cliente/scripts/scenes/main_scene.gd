extends Control


var _receiver: Receiver
var _sender_ping: PingSenderMessage


@export_category('Ping Settings')
@export var _ping_interval := 2.0
@export var _time_elapsed := 0.0


@export_category('Interfaces')
@export var _ping_menu_label := Label


var _client: Socket.PacketClient
var _constants: Constants
var _scene_tree: SceneTree


func _ready() -> void:
	_scene_tree = get_tree()
	_client = Network.async_socket
	_client.endianness = Socket.Endianness.Little
	_constants = Constants.new()

	_connect_to_server()

	_receiver = Receiver.new(_scene_tree)
	_sender_ping = PingSenderMessage.new()
	_client.packet_received.connect(_on_packet_received)
	_client.connected.connect(_on_connected)
	_client.disconnected.connect(_on_disconnected)


func _process(delta) -> void:
	if _client != null:
		_client.poll()

		_time_elapsed += delta

		if _time_elapsed >= _ping_interval:
			_sender_ping.send_data(_client)
			_time_elapsed = 0.0


func _connect_to_server() -> void:
	var result = await _client.connect_to_host(_constants.host, _constants.port)

	if result != OK:
		_ping_menu_label.text = "Não foi possível se conectar ao servidor!"


func _on_connected() -> void:
	_ping_menu_label.text = 'Conectado ao servidor! Sincronizando...'


func _on_packet_received(data: PackedByteArray) -> void:
	_receiver.receiver_data(data)


func _on_disconnected() -> void:
	_ping_menu_label.text = 'Não foi possível se conectar ao servidor!'
