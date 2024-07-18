extends Control

@onready var actual_options:Control = $Options

var is_open:bool = false

func _ready():
	visible = false

func _process(delta):
	if is_open: move_to_front()

func _input(event):
	if event.is_action_pressed("options"):
		if !is_open: open()
		else: close()

func _gui_input(event):
	if !is_open: return
	if event is InputEventMouseButton:
		if event.position.x > 432: close()

var tween:Tween
func open():
	if tween: tween.kill()
	is_open = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	modulate.a = 0
	actual_options.position.x = -432
	visible = true
	tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1, 0.4)
	tween.tween_property(actual_options, "position:x", 0, 0.2)
func close():
	if tween: tween.kill()
	is_open = false
	mouse_filter = Control.MOUSE_FILTER_PASS
	tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0, self.modulate.a * 0.1)
	await tween.finished
	visible = false
	grab_focus()
