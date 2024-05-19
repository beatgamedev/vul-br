extends Node
class_name LobbyPlayer

var peer_id:int = 0
var local_player:bool:
	get: return peer_id == multiplayer.get_unique_id()

var discord_id:String
var username:String
