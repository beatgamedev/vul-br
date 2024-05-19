extends Node
class_name Lobby

var players:Dictionary

@rpc("authority", "call_local", "reliable")
func player_added(peer_id:int, username:int):
	var player = LobbyPlayer.new()
	player.peer_id = peer_id
	player.username = username
	player.set_multiplayer_authority(peer_id)
	add_child(player)
	players[peer_id] = player
func player_removed(peer_id:int):
	var player = players.get(peer_id)
	if player != null:
		players.erase(peer_id)
		player.queue_free()
