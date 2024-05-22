extends Control

signal map_selected(map:Map)

@onready var button_container = $S/M/V
@onready var template_button = $S/M/V/MapButton

func _ready():
	button_container.remove_child(template_button)

	_create_buttons()

var selected_map:Map
var selected_button:Button
func _button_pressed(button):
	button.button_pressed = true
	if button == selected_button: return
	if selected_button != null: selected_button.button_pressed = false
	selected_button = button
	selected_map = selected_button.get_meta("map")
	map_selected.emit(selected_map)

func _create_button(map:Map):
	var button:Button = template_button.duplicate()
	button.name = map.id
	button.set_meta("map", map)
	button_container.add_child(button)
	button.pressed.connect(_button_pressed.bind(button))
	_update_button(button)
	return button
func _create_buttons():
	var maps = Vulnus.maps
	for map in maps:
		_create_button(map)
func _update_button(button):
	var map:Map = button.get_meta("map")
	button.get_node("Title").text = map.title
	button.get_node("H/Mappers").text = map.mappers_string
	button.get_node("H/Difficulty").text = map.difficulty
