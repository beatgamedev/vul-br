extends Control

func _on_map_selected(map:Map):
	Online.local_player.selected_map_id = map.id
	Online.local_player.selected_map_title = map.title
	Online.local_player.selected_map_mappers = map.mappers_string
	Online.local_player.selected_map_difficulty = map.difficulty
	$V/NoSelection.visible = false
	$V/SelectedMap/Title.text = map.title
	$V/SelectedMap/Mappers.text = map.mappers_string
	$V/SelectedMap/Difficulty.text = map.difficulty
	$V/SelectedMap.visible = true
