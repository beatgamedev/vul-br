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
@export var value:String:
	set(_value):
		value = _value
		if Engine.is_editor_hint(): $H/LineEdit.text = _value
		
@export_category("LineEdit")
@export var max_length:int:
	set(value):
		max_length = value
		if Engine.is_editor_hint(): $H/LineEdit.max_length = value
@export var min_size:int:
	set(value):
		min_size = value
		if Engine.is_editor_hint(): $H/LineEdit.custom_minimum_size.x = value

func _ready():
	if Engine.is_editor_hint(): return
	$H/Label.text = text
	$H/LineEdit.max_length = max_length
	$H/LineEdit.custom_minimum_size.x = min_size
	value = Vulnus.settings.get(target, false)
	$H/LineEdit.text = value

func _update(value):
	if Engine.is_editor_hint(): return
	Vulnus.settings[target] = value
	Vulnus.save_settings()
