extends Node
class_name Lobby

func _process(delta):
	if is_multiplayer_authority(): _server_process(delta)
	_client_process(delta)

func _server_process(delta):
	pass
func _client_process(delta):
	pass
