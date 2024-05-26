extends Control

func _on_map_selected(map:Map):
	Online.local_player.select_map.rpc(map.id, map.title, map.mappers_string, map.difficulty)
	$V/NoSelection.visible = false
	$V/SelectedMap/Title.text = map.title
	$V/SelectedMap/H/Mappers.text = map.mappers_string
	$V/SelectedMap/H/Difficulty.text = map.difficulty
	$V/SelectedMap.visible = true
