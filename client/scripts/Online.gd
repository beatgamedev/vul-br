extends Node

signal connected
signal disconnected
signal player_added(peer_id:int, player:LobbyPlayer)
signal player_removed(peer_id:int, player:LobbyPlayer)

func _ready():
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_disconnected)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

	connected.connect(func(): get_tree().change_scene_to_file("res://scenes/LobbyMenu.tscn"))

func host(port:int=4444):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 32)
	if error != OK: return error
	multiplayer.multiplayer_peer = peer
	_on_connected_ok()
	print("Hosting on port %s" % port)
	return OK
func join(address:String="127.0.0.1", port:int=4444):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, port)
	if error != OK: return error
	multiplayer.multiplayer_peer = peer
	print("Connecting")
	return OK

var lobby:Lobby
func create_lobby():
	lobby = preload("res://prefabs/Lobby.tscn").instantiate()
	lobby.set_multiplayer_authority(1)
	lobby.name = "Lobby"
	add_child(lobby)

var local_player:LobbyPlayer
var players:Dictionary = {}

func create_local_player():
	var local_peer_id = multiplayer.get_unique_id()
	_player_connected(local_peer_id)
	local_player = players.get(local_peer_id)
	local_player.display_name = "PlayerName"

func _player_connected(peer_id:int):
	var player = preload("res://prefabs/Player.tscn").instantiate()
	player.name = str(peer_id)
	player.peer_id = peer_id
	player.set_multiplayer_authority(peer_id)
	players[peer_id] = player
	add_child(player)
	player_added.emit(peer_id, player)
func _player_removed(peer_id:int):
	var player = players.get(peer_id)
	if player:
		player_removed.emit(peer_id, player)
		player.queue_free()
	players.erase(peer_id)
func _cleanup():
	multiplayer.multiplayer_peer = null
	players = {}
	lobby = null
	for node in get_children():
		node.queue_free()

func _on_connected_ok():
	print("Connected")
	create_lobby()
	print("Created lobby")
	create_local_player()
	print("Created local player")
	connected.emit()
func _on_connected_fail():
	print("Connection failed")
	_cleanup()
func _on_disconnected():
	print("Disconnected")
	_cleanup()
func _on_peer_connected(peer_id:int):
	print("Peer %s connected" % peer_id)
	_player_connected(peer_id)
func _on_peer_disconnected(peer_id:int):
	print("Peer %s disconnected" % peer_id)
	_player_removed(peer_id)
