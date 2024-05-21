extends Node
class_name LobbyPlayer

signal updated

var peer_id:int = 0
var local_player:bool:
	get: return peer_id == multiplayer.get_unique_id()

@export var display_name:String = "Player"

@export var selected_map_id:String
@export var selected_map_title:String
@export var selected_map_mappers:String
@export var selected_map_difficulty:String

func _on_sync(): updated.emit()
