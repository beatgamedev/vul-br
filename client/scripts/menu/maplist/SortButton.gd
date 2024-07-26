@tool
extends Node

signal toggled(ascending:bool)

@export_category("Options")
@export var text: String:
	get: return $H/Label.text
	set(value): $H/Label.text = value
@export var ascending: bool = false

func _process(delta: float) -> void:
	$H/Up.visible = ascending
	$H/Down.visible = !ascending

func toggle_ascending() -> void:
	ascending = !ascending
	toggled.emit(ascending)
