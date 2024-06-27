class_name PingReceiverMessage


extends RefCounted


func receiver(scene_tree: SceneTree, buffer: StreamPeerBuffer) -> void:
	var server_time := buffer.get_32()
	var client_time_float := Time.get_unix_time_from_system()
	var client_time = round(client_time_float)
	var latency = client_time - server_time
	var ping_to_draw := 'Syncing'
	
	var ping_label_location := '/root/main/ping_label'
	var ping_label := scene_tree.root.get_node(ping_label_location) as Label

	if latency >= 0 and latency <= 5:
		ping_to_draw = 'Local'
	elif latency > 5:
		ping_to_draw = str(latency) + 'ms'

	ping_label.text = ping_to_draw
