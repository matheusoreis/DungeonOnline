class_name PingReceiverMessage


extends RefCounted


func receiver(scene_tree: SceneTree, buffer: StreamPeerBuffer) -> void:
	var sender_time := Globals.send_ping_time
	var current_time := Time.get_unix_time_from_system()
	var latency = round(sender_time - current_time)
	var ping_to_draw := ''
	
	var ping_label_location := '/root/main/PingLabel'
	var ping_label := scene_tree.root.get_node(ping_label_location) as Label

	if latency >= 0 and latency <= 5:
		ping_to_draw = 'Local'
	elif latency > 5:
		ping_to_draw = str(latency) + 'ms'

	ping_label.text = ping_to_draw
