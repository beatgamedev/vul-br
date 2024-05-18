extends Node

@export var game:Game

@onready var placement = $SubViewport/Control/V/Placement
@onready var score = $SubViewport/Control/V/Score
@onready var accuracy = $SubViewport/Control/V/Accuracy

func _ready():
	game.score.score_changed.connect(update_score)
	game.score.combo_changed.connect(update_accuracy)

var _score:int = 0
var _target_score:int = 0
var _score_tween:Tween
func update_score():
	if _score_tween != null: _score_tween.kill()
	_score = _target_score
	_target_score = game.score.score
	_score_tween = (create_tween()
	.set_ease(Tween.EASE_OUT)
	.set_trans(Tween.TRANS_EXPO))
	_score_tween.tween_property(self, "_score", _target_score, 0.4)
	_score_tween.play()

var _accuracy:float = 1
var _target_accuracy:float = 1
var _accuracy_tween:Tween
func update_accuracy():
	if _accuracy_tween != null: _accuracy_tween.kill()
	_accuracy = _target_accuracy
	_target_accuracy = float(game.score.hits) / float(game.score.total)
	_accuracy_tween = (create_tween()
	.set_ease(Tween.EASE_OUT)
	.set_trans(Tween.TRANS_EXPO))
	_accuracy_tween.tween_property(self, "_accuracy", _target_accuracy, 0.1)
	_accuracy_tween.play()

func _process(delta):
	score.text = Vulnus.comma_separate(_score)
	accuracy.text = "%.2f%%" % (_accuracy * 100)
