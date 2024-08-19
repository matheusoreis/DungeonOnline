class_name Main extends Control


var _processor: Processor
var _client: WebSocketClient
var _constants: Constants
var _scene_tree: SceneTree


func _ready() -> void:
    _scene_tree = get_tree()
    _client = Network.websocket
    _constants = Constants.new()
    _processor = Processor.new(_scene_tree)

    _connect_to_server()
    _client.packet_received.connect(_on_packet_received)
    _client.connected.connect(_on_connected)
    _client.disconnected.connect(_on_disconnected)


func _process(delta) -> void:
    if _client != null:
        _client.poll()


func _connect_to_server() -> void:
    var result = await _client.connect_to_host(_constants.host, _constants.port)

    if result != OK:
        _on_disconnected()


func _on_connected() -> void:
    var alert_scene := preload("res://scenes/ui/alert/alert_ui.tscn") as PackedScene
    var alert_panel := alert_scene.instantiate() as AlertUI
    var alert_panel_location := '/root/main/Shared/AlertPanel/AlertsVBox'
    var alert_vbox := _scene_tree.root.get_node(alert_panel_location) as VBoxContainer
    alert_panel.message.text = 'Conectado ao servidor!'
    alert_vbox.add_child(alert_panel)


func _on_packet_received(data: PackedByteArray) -> void:
    if data.size() == 0:
        _client.disconnect_from_host()
        return

    var packet := Packet.new()
    packet = packet.from_packed_byte_array(data)
    _processor.process_message(packet)


func _on_disconnected() -> void:
    var alert_scene := preload("res://scenes/ui/alert/alert_ui.tscn") as PackedScene
    var alert_panel := alert_scene.instantiate() as AlertUI
    var alert_panel_location := '/root/main/Shared/AlertPanel/AlertsVBox'
    var alert_vbox := _scene_tree.root.get_node(alert_panel_location) as VBoxContainer
    alert_panel.message.text = 'Não foi possível se conectar ao servidor!'
    alert_vbox.add_child(alert_panel)
