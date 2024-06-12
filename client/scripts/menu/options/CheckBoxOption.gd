#@tool
extends Control
#
#@export_category("Options")
#@export var text:String:
	#get: return $H/Label.text
	#set(value): $H/Label.text = value
#@export var tooltip:String:
	#get: return tooltip_text
	#set(value): tooltip_text = value
#@export var target:String
#@export var value:bool:
	#get: return $H/CheckBox.button_pressed
	#set(value): $H/CheckBox.button_pressed = value
#
#func _ready():
	#if Engine.is_editor_hint(): return
	#self.value = Vulnus.settings.get(target, false)
#
#func _update(value):
	#if Engine.is_editor_hint(): return
	#Vulnus.settings[target] = value
	#Vulnus.save_settings()
