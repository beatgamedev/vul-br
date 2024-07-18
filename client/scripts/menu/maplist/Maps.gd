extends PanelContainer

signal map_selected

@onready var map_button_prefab: PackedScene = preload("res://prefabs/maplist/MapButton.tscn")
@onready var button_grid: GridContainer = $M/Content/M/G

var buttons:Array = []

func _ready():
	create_buttons()

func create_buttons():
	for map in Vulnus.maps:
		var button = map_button_prefab.instantiate()
		button.map = map
		button.pressed.connect(select_map.bind(button))
		buttons.append(button)
		button_grid.add_child(button)

func select_map(button):
	map_selected.emit(button.map)

func sort_buttons(sort_by:String, direction:bool):
	var sort_func = func(a, b):
		return a.map.get(sort_by) > b.map.get(sort_by)
	buttons.sort_custom(sort_func)
	if !direction: buttons.reverse()
	for i in buttons.size():
		button_grid.move_child(buttons[i], i)

func filter_buttons(search_text:String):
	if search_text.length() == 0:
		for button in buttons:
			button.visible = true
		return
	for button in buttons:
		var title_match = button.map.title.containsn(search_text)
		var mapper_match = button.map.mappers_string.containsn(search_text)
		button.visible = title_match or mapper_match
