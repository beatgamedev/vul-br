extends Node
class_name LobbyPlayer

signal updated

var peer_id:int = 0
var local_player:bool:
	get: return peer_id == multiplayer.get_unique_id()

@export var display_name:String

func _on_sync(): updated.emit()
