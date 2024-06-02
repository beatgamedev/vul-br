@tool
extends Control

@export_category("Options")
@export var text:String:
	get: return $H/Label.text
	set(value): $H/Label.text = value
@export var tooltip:String:
	get: return tooltip_text
	set(value): tooltip_text = value
@export var target:String
@export var value:float:
	get: return $H/SpinBox.value
	set(value): $H/SpinBox.value = value

@export_category("$H/SpinBox")
@export var prefix:String:
	get: return $H/SpinBox.prefix
	set(value): $H/SpinBox.prefix = value
@export var suffix:String:
	get: return $H/SpinBox.suffix
	set(value): $H/SpinBox.suffix = value
@export var allow_greater:bool:
	get: return $H/SpinBox.allow_greater
	set(value): $H/SpinBox.allow_greater = value
@export var allow_lesser:bool:
	get: return $H/SpinBox.allow_lesser
	set(value): $H/SpinBox.allow_lesser = value
@export var max_value:float:
	get: return $H/SpinBox.max_value
	set(value): $H/SpinBox.max_value = value
@export var min_value:float:
	get: return $H/SpinBox.min_value
	set(value): $H/SpinBox.min_value = value
@export var step:float:
	get: return $H/SpinBox.step
	set(value): $H/SpinBox.step = value
@export var custom_arrow_step:float:
	get: return $H/SpinBox.custom_arrow_step
	set(value): $H/SpinBox.custom_arrow_step = value

func _ready():
	if Engine.is_editor_hint(): return
	self.value = Vulnus.settings.get(target, 0)

func _update(value):
	if Engine.is_editor_hint(): return
	Vulnus.settings[target] = value
	Vulnus.save_settings()
