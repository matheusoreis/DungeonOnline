class_name SpawnToAllPlayerReceiverMessage


extends RefCounted


func receiver(scene_tree: SceneTree, buffer: StreamPeerBuffer) -> void:
	var player_id: int = buffer.get_32()
	var player_name: String = buffer.get_utf8_string()
	var player_map: int = buffer.get_16()
	var player_map_x: int = buffer.get_16()
	var player_map_y: int = buffer.get_16()
	var player_direction: int = buffer.get_8()
	var local_player : bool = false

	var player_scene := preload('res://scenes/players/base_character.tscn').instantiate() as BaseCharacter
	player_scene.is_local_player = local_player
	player_scene.player_id = player_id
	player_scene.player_name = player_name
	player_scene.name = str(player_id)
	player_scene.global_position = Vector2(player_map_x, player_map_y)
	scene_tree.root.add_child(player_scene)
