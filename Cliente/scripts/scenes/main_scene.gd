extends Control


var _processor: Processor
var _ping_message: PingMessage


@export_category('Interfaces')
@export var _ping_menu_label := Label

@export_category('Ping Settings')
@export var _ping_interval := 1.0
@export var _time_elapsed := 0.0


var _client: WebSocketClient
var _constants: Constants
var _scene_tree: SceneTree


func _init() -> void:
	pass


func _ready() -> void:
	get_window().size.y = DisplayServer.screen_get_size().y

	DisplayServer.window_is_focused()

	ProjectSettings.set_setting(
		"display/window/size/always_on_top", true
	)

	var window_position: Vector2 = get_window().position
	get_window().position = Vector2(window_position.x * 2, 0)


	_scene_tree = get_tree()
	_client = Network.websocket
	_constants = Constants.new()

	_connect_to_server()

	_processor = Processor.new()
	_ping_message = PingMessage.new()

	_register_packet_handlers()

	_client.packet_received.connect(_on_packet_received)
	_client.connected.connect(_on_connected)
	_client.disconnected.connect(_on_disconnected)


func _process(delta) -> void:
	if _client != null:
		_client.poll()

		_time_elapsed += delta
		if _time_elapsed >= _ping_interval:
			_ping_message.send()
			_time_elapsed = 0.0


func _connect_to_server() -> void:
	var result = await _client.connect_to_host(_constants.host, _constants.port)

	if result != OK:
		_ping_menu_label.text = "Não foi possível se conectar ao servidor!"


func _on_connected() -> void:
	_ping_menu_label.text = 'Conectado ao servidor! Sincronizando...'


func _on_packet_received(data: PackedByteArray) -> void:
	if data.size() == 0:
		# TODO: Mostrar um alerta
		_client.disconnect_from_host()
		return

	var packet := Packet.new()
	packet.from_packed_byte_array(data)
	_processor.process_message(packet)


func _on_disconnected() -> void:
	_ping_menu_label.text = 'Não foi possível se conectar ao servidor!'


func _register_packet_handlers() -> void:
	_processor.register_message(ServerHeaders.list.ping, Callable(self, "_on_ping_packet"))


func _on_ping_packet(packet: Packet) -> void:
	_ping_message.handle(packet, _scene_tree)
