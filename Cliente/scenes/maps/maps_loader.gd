extends Node


var maps := {
	1 : "res://scenes/maps/arredores_de_eldor.tscn",
}

func get_map(map_id: int) -> PackedScene:
	if maps.has(map_id):
		return load(maps[map_id]) as PackedScene
	else:
		print("Mapa não encontrado: ", map_id)
		return null
