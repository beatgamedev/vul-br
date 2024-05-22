extends Node
class_name Lobby

@export var in_match:bool = false

func _process(delta):
	if is_multiplayer_authority(): _server_process(delta)
	_client_process(delta)

func _server_process(delta):
	pass
func _client_process(delta):
	pass

@rpc("authority", "call_local", "reliable")
func start_game(map_id:String):
	var map = Vulnus.maps_by_id.get(map_id)
	if map == null:
		push_error("Map is missing")
		return
	var game = preload("res://scenes/Game.tscn").instantiate()
	game.map = map
	Globals.change_scene(game)
