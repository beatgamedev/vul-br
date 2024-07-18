extends Control

var _thread:Thread

@onready var progress_label = $C/P/M/V/ProgressLabel
@onready var progress_bar = $C/P/M/V/ProgressBar

func _ready():
	$FadeIn.visible = true
	_fade_in.call_deferred()
	
	await get_tree().create_timer(1).timeout
	
	Vulnus.on_init_stage.connect(_init_stage)
	Vulnus.on_init_substage.connect(_init_substage)
	Vulnus.on_init_finished.connect(_init_finished)
	
	_thread = Thread.new()
	_thread.start.call_deferred(Vulnus.init)

func _exit_tree():
	if _thread.is_started(): _thread.wait_to_finish()

func _fade_in():
	$FadeIn.visible = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property($FadeIn, "modulate:a", 0, 0.2)

func _init_stage(text:String, stage:int, max_stage:int):
	progress_label.text = text
	progress_bar.value = stage
	progress_bar.max_value = max_stage
func _init_substage(text:String, stage:int, max_stage:int, substage:int, max_substage:int):
	progress_label.text = text
	progress_bar.value = float(stage) + float(float(substage) / float(max_substage))
	progress_bar.max_value = max_stage

func _init_finished():
	var menu = preload("res://scenes/Lobbies.tscn").instantiate()
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property($C, "modulate:a", 0, 0.5)
	await tween.finished
	
	_thread.wait_to_finish()
	
	Globals.change_scene(menu)
