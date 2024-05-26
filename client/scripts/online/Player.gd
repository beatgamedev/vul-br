extends Node
class_name LobbyPlayer

signal updated
signal map_selected

var peer_id:int = 0
var local_player:bool:
	get: return peer_id == multiplayer.get_unique_id()

@export var display_name:String = "Player"

@rpc("authority", "call_local", "reliable")
func select_map(id:String, title:String, mappers:String, difficulty:String):
	selected_map = true
	selected_map_id = id
	selected_map_title = title
	selected_map_mappers = mappers
	selected_map_difficulty = difficulty
	map_selected.emit(id)
var selected_map:bool = false
var selected_map_id:String
var selected_map_title:String
var selected_map_mappers:String
var selected_map_difficulty:String

func _on_sync(): updated.emit()
