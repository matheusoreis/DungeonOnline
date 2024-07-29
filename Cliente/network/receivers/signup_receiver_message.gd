class_name SignUpReceiverMessage


extends RefCounted


func receiver(scene_tree: SceneTree, buffer: StreamPeerBuffer) -> void:
	var signin_panel := scene_tree.root.get_node('/root/main/SignInPanel') as PanelContainer
	var signup_panel := scene_tree.root.get_node('/root/main/SignUpPanel') as PanelContainer

	signin_panel.show()
	signup_panel.hide()

	var alert_scene := preload('res://scenes/ui/alert_panel.tscn').instantiate() as AlertPanel
	var alert_type := 0
	var alert_message := buffer.get_utf8_string()

	alert_scene.set_message(alert_message)
	alert_scene.set_type(alert_type)
	scene_tree.root.add_child(alert_scene)
