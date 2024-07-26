extends Node
class_name Lobby

@export var in_match: bool = false

func _process(delta: float) -> void:
	if is_multiplayer_authority(): _server_process(delta)
	_client_process(delta)

func _server_process(delta: float) -> void:
	pass
func _client_process(delta: float) -> void:
	pass

@rpc("authority", "call_local", "reliable")
func start_game(map_id: String) -> void:
	var game: Game = Vulnus.load_game(map_id)
	if game == null:
		push_error("Map doesn't exist")
		return
	Globals.change_scene(game)
