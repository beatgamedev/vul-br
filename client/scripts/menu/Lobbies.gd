extends Control

func _ready() -> void:
	Online.connected.connect(switch_to_lobby)

func switch_to_lobby() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/Lobby.tscn")
