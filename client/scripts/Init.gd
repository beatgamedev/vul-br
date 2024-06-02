extends Control

func _ready():
	_init_finished.call_deferred()

func _init_finished():
	var menu = preload("res://scenes/Menu.tscn").instantiate()
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($M, "modulate:a", 0, 1.5)
	tween.play()
	await tween.finished
	
	Globals.change_scene(menu)
