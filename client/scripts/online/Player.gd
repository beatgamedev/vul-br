extends Node
class_name LobbyPlayer

var peer_id:int = 0
var local_player:bool:
	get: return peer_id == multiplayer.get_unique_id()
var data:Dictionary
var connected:bool:
	get: return data != null

var display_name:String:
	get: return data.get("display_name", "Player")
