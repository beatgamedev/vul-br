extends VBoxContainer

signal map_chosen(map: Map)
signal map_selected(map: Map)

var selected_map: Map

func select_map(map: Map) -> void:
	if map == selected_map:
		map_chosen.emit(selected_map)
		return
	selected_map = map
	map_selected.emit(map)
