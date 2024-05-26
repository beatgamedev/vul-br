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
	var game = Vulnus.load_game(map_id)
	if game == null:
		push_error("Map doesn't exist")
		return
	Globals.change_scene(game)
