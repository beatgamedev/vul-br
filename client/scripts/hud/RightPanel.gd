extends Node

@export var game: Game

@onready var multiplier_spinner: TextureProgressBar = $SubViewport/Control/V/Multiplier/Spinner
@onready var multiplier_label: Label = $SubViewport/Control/V/Multiplier/Label
@onready var combo: Label = $SubViewport/Control/V/Combo
@onready var misses: Label = $SubViewport/Control/V/Misses

func _ready() -> void:
	update_multiplier()
	update_combo()
	game.score.multiplier_changed.connect(update_multiplier)
	game.score.combo_changed.connect(update_combo)

var _multiplier_tween: Tween
func update_multiplier() -> void:
	if _multiplier_tween != null: _multiplier_tween.kill()
	_multiplier_tween = (create_tween()
	.set_ease(Tween.EASE_OUT)
	.set_trans(Tween.TRANS_EXPO))
	_multiplier_tween.tween_property(multiplier_spinner, "value", game.score.sub_multiplier, 0.2)
	multiplier_label.text = str(game.score.multiplier)

func update_combo() -> void:
	combo.text = str(game.score.combo)
	misses.text = str(game.score.misses)
