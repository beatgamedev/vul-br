extends Node

@export var game:Game

@onready var health_progress = $SubViewport/Control/Health

func _ready():
	update_health()
	game.score.health_changed.connect(update_health)

var _tween:Tween
func update_health():
	if _tween != null: _tween.kill()
	_tween = (create_tween()
	.set_ease(Tween.EASE_OUT)
	.set_trans(Tween.TRANS_CUBIC))
	_tween.tween_property(health_progress, "value", game.score.health, 0.2)
	_tween.play()
