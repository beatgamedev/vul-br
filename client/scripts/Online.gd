extends Node

var lobby:Lobby
func join_lobby():
	lobby = Lobby.new()
	lobby.set_multiplayer_authority(1)
func leave_lobby():
	multiplayer.multiplayer_peer.close()
	lobby = null

func _ready():
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.server_disconnected.connect(disconnected_from_server)
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)

func connected_to_server():
	join_lobby()
func disconnected_from_server():
	pass
func peer_connected(peer_id:int):
	if multiplayer.is_server():
		lobby.player_added.rpc(peer_id, "John")
func peer_disconnected(peer_id:int):
	lobby.player_removed(peer_id)
