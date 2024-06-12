extends Control

func _ready():
	Online.connected.connect(switch_to_lobby)

func switch_to_lobby():
	get_tree().change_scene_to_file("res://scenes/Lobby.tscn")
