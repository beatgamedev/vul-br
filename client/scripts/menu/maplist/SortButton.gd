@tool
extends Node

signal toggled(ascending:bool)

@export var label:String:
	get: return $H/Label.text
	set(value): $H/Label.text = value
@export var ascending:bool = false

func _process(delta):
	$H/Up.visible = ascending
	$H/Down.visible = !ascending

func toggle_ascending():
	ascending = !ascending
	toggled.emit(ascending)
