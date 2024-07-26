@tool
extends Control

@export_category("Options")
@export var text: String:
	set(value):
		text = value
		if Engine.is_editor_hint(): $H/Label.text = value
@export var tooltip: String:
	get: return tooltip_text
	set(value): tooltip_text = value
@export var target: String
@export var value: float:
	set(_value):
		value = _value
		if Engine.is_editor_hint(): $H/SpinBox.value = _value

@export_category("SpinBox")
@export var prefix: String:
	set(value):
		prefix = value
		if Engine.is_editor_hint(): $H/SpinBox.prefix = value
@export var suffix: String:
	set(value):
		suffix = value
		if Engine.is_editor_hint(): $H/SpinBox.suffix = value
@export var allow_greater: bool:
	set(value):
		allow_greater = value
		if Engine.is_editor_hint(): $H/SpinBox.allow_greater = value
@export var allow_lesser: bool:
	set(value):
		allow_lesser = value
		if Engine.is_editor_hint(): $H/SpinBox.allow_lesser = value
@export var max_value: float:
	set(value):
		max_value = value
		if Engine.is_editor_hint(): $H/SpinBox.max_value = value
@export var min_value: float:
	set(value):
		min_value = value
		if Engine.is_editor_hint(): $H/SpinBox.min_value = value
@export var step: float:
	set(value):
		step = value
		if Engine.is_editor_hint(): $H/SpinBox.step = value
@export var custom_arrow_step: float:
	set(value):
		custom_arrow_step = value
		if Engine.is_editor_hint(): $H/SpinBox.custom_arrow_step = value

func _ready() -> void:
	if Engine.is_editor_hint(): return
	$H/Label.text = text
	$H/SpinBox.prefix = prefix
	$H/SpinBox.suffix = suffix
	$H/SpinBox.allow_greater = allow_greater
	$H/SpinBox.allow_lesser = allow_lesser
	$H/SpinBox.max_value = max_value
	$H/SpinBox.min_value = min_value
	$H/SpinBox.step = step
	$H/SpinBox.custom_arrow_step = custom_arrow_step
	value = Vulnus.settings.get(target, 0)
	$H/SpinBox.value = value

func _update(value: float) -> void:
	if Engine.is_editor_hint(): return
	Vulnus.settings[target] = value
	Vulnus.save_settings()
