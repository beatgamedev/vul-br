@tool
extends Control

@export_category("Options")
@export var text:String:
	set(value):
		text = value
		if Engine.is_editor_hint(): $H/Label.text = value
@export var tooltip:String:
	get: return tooltip_text
	set(value): tooltip_text = value
@export var target:String
@export var value:bool:
	set(_value):
		value = _value
		if Engine.is_editor_hint(): $H/CheckBox.button_pressed = _value

func _ready():
	if Engine.is_editor_hint(): return
	$H/Label.text = text
	value = Vulnus.settings.get(target, false)
	$H/CheckBox.button_pressed = value

func _update(value):
	if Engine.is_editor_hint(): return
	Vulnus.settings[target] = value
	Vulnus.save_settings()
