extends PanelContainer

signal filters_updated(search: String)
signal sorts_updated(key: String, direction: bool)

var name_sort: bool = false
var mapper_sort: bool = false

var search_text: String = ""

func _name_sort_changed(value: bool) -> void:
	name_sort = value
	sorts_updated.emit("title", value)
func _mapper_sort_changed(value: bool) -> void:
	mapper_sort = value
	sorts_updated.emit("mappers_string", value)

func _search_text_changed(value: String) -> void:
	search_text = value
	filters_updated.emit(value)
