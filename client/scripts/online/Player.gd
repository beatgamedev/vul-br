extends Node
class_name LobbyPlayer

signal map_selected
signal score_updated

var peer_id: int = 0
var local_player: bool:
	get: return peer_id == multiplayer.get_unique_id()

var awaiting_info: bool = true

var display_name: String = "Player"

@rpc("authority", "call_local", "reliable")
func select_map(id: String, title: String, mappers: String, difficulty: String) -> void:
	selected_map = true
	selected_map_id = id
	selected_map_title = title
	selected_map_mappers = mappers
	selected_map_difficulty = difficulty
	map_selected.emit(id)
var selected_map: bool = false
var selected_map_id: String
var selected_map_title: String
var selected_map_mappers: String
var selected_map_difficulty: String

@rpc("authority", "call_local", "unreliable_ordered")
func update_score(score: int, combo: int, health: int) -> void:
	self.score = score
	self.combo = combo
	self.health = health
	score_updated.emit()
var score: int = 0
var combo: int = 0
var health: int = 0
