extends PanelContainer

signal filters_updated
signal sorts_updated

var name_sort:bool = false
var mapper_sort:bool = false

func _name_sort_changed(value:bool):
	name_sort = value
	sorts_updated.emit()
func _mapper_sort_changed(value:bool):
	mapper_sort = value
	sorts_updated.emit()
