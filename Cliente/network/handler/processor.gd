class_name Processor extends RefCounted


var handlers: Dictionary = {}
var _scene_tree: SceneTree
var _ping_message: PingMessage
var _signin_message: SignInMessage


func _init(scene_tree) -> void:
    _scene_tree = scene_tree
    _ping_message = PingMessage.new()
    _signin_message = SignInMessage.new()

    _register_packet_handlers()


func register_message(id: int, processor: Callable) -> void:
    handlers[id] = processor


func process_message(packet: Packet) -> void:
    var handler = handlers.get(packet.id)

    if not handler:
        var alert_scene := preload("res://scenes/ui/alert/alert_ui.tscn") as PackedScene
        var alert_panel := alert_scene.instantiate() as AlertUI
        var alert_panel_location := '/root/main/Shared/AlertPanel/AlertsVBox'
        var alert_vbox := _scene_tree.root.get_node(alert_panel_location) as VBoxContainer
        alert_panel.message.text = 'Erro ao precessar o pacote com o id: !' + str(packet.id)
        alert_vbox.add_child(alert_panel)
        return

    handler.call(packet)


func _register_packet_handlers() -> void:
    register_message(ServerHeaders.list.ping, func(packet: Packet) -> void:
        var ping_message = PingMessage.new()
        ping_message.handle(packet, _scene_tree)
    )

    register_message(ServerHeaders.list.alert, func(packet: Packet) -> void:
        var alert_message = AlertMessage.new()
        alert_message.handle(packet, _scene_tree)
    )

    register_message(ServerHeaders.list.signIn, func(packet: Packet) -> void:
        var signin_message = SignInMessage.new()
        signin_message.handle(packet, _scene_tree)
    )
