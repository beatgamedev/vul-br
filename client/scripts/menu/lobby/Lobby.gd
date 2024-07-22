extends VBoxContainer

@export var music_player: AudioStreamPlayer

func _on_map_selected(map: Map):
	Online.local_player.select_map.rpc(map.id, map.title, map.mappers_string, map.difficulty)
	map.load_music()
	music_player.stream = map.music
	music_player.play()

func _on_map_chosen(map: Map):
	if Online.local_player.peer_id != 1:
		print("Must be host to start map!")
		return
	Online.lobby.start_game.rpc(map.id)
