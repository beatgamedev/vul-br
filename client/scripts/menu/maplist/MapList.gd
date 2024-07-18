extends VBoxContainer

signal map_chosen
signal map_selected

var selected_map: Map

func select_map(map):
	if map == selected_map:
		map_chosen.emit(selected_map)
		return
	selected_map = map
	map_selected.emit(map)
