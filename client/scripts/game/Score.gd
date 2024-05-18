class_name Score

signal score_changed
signal multiplier_changed
signal combo_changed
signal health_changed

var _combo_score:int = 0
var _max_combo_score:int = 120
var _base_score:int = 0
var _max_base_score:int = 120
var score:int:
	get:
		var combo_portion = float(_combo_score) / float(_max_combo_score)
		var accuracy_portion = float(_base_score) / float(_max_base_score)
		return (
			(500000 * combo_portion) +
			(500000 * pow(accuracy_portion, 5))
		)

var multiplier:int = 1
var sub_multiplier:int = 0

var combo:int = 0
var max_combo:int = 0

var hits:int = 0
var misses:int = 0
var total:int:
	get: return hits + misses

var health:int = 40
var failed:bool = false

func add_hit(points:int):
	hits += 1

	combo += 1
	max_combo = max(combo, max_combo)
	combo_changed.emit()

	if health < 40 and !failed:
		health = min(health + 5, 40)
		health_changed.emit()

	if sub_multiplier <= 9:
		sub_multiplier += 1
		if sub_multiplier == 10 and multiplier < 8:
			multiplier += 1
			sub_multiplier = 0
		multiplier_changed.emit()

	_combo_score += sqrt(multiplier)
	_base_score += 1
	score_changed.emit()
func add_miss():
	misses += 1

	max_combo = max(combo, max_combo)
	combo = 0
	combo_changed.emit()

	if !failed:
		health = max(health - 8, 0)
		if health == 0: failed = true
		health_changed.emit()

	multiplier = max(1, multiplier - 1)
	sub_multiplier = 0
	multiplier_changed.emit()
