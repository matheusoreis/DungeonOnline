class_name AlertReceiverMessage


extends RefCounted


func receiver(scene_tree: SceneTree, buffer: StreamPeerBuffer) -> void:
	var alert_scene := preload('res://scenes/ui/alert_panel.tscn').instantiate() as AlertPanel
	var alert_type := buffer.get_8()
	var alert_message := buffer.get_utf8_string()
	
	alert_scene.set_message(alert_message)
	alert_scene.set_type(alert_type)
	scene_tree.root.add_child(alert_scene)
