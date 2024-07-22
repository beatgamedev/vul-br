class_name Score

signal score_changed
var _is_score_changed:bool = false
signal multiplier_changed
var _is_multiplier_changed:bool = false
signal combo_changed
var _is_combo_changed:bool = false
signal health_changed
var _is_health_changed:bool = false

var _combo_score:int = 0
var _max_combo_score:int = 0
var _base_score:int = 0
var _max_base_score:int = 0
var score:int:
	get:
		var combo_progress = float(_combo_score) / float(_max_combo_score)
		var accuracy_progress = float(_base_score) / float(_max_base_score)
		return (
			(500000 * self.accuracy * combo_progress) +
			(500000 * pow(self.accuracy, 5) * accuracy_progress)
		)

var multiplier:int = 1
var sub_multiplier:int = 0

var combo:int = 0
var max_combo:int = 0

var hits:int = 0
var misses:int = 0
var total:int:
	get: return hits + misses
var accuracy:float:
	get: return 1 if hits <= 0 else float(hits) / float(self.total)

var health:int = 40
var failed:bool = false

func add_hit(points:int):
	hits += 1

	combo += 1
	max_combo = max(combo, max_combo)
	_is_combo_changed = true

	if health < 40 and !failed:
		health = min(health + 5, 40)
		_is_health_changed = true

	if sub_multiplier <= 9:
		sub_multiplier += 1
		if sub_multiplier == 10 and multiplier < 8:
			multiplier += 1
			sub_multiplier = 0
		_is_multiplier_changed = true
		
	if failed and multiplier == 8 and sub_multiplier == 10:
		failed = false
		health += 1
		_is_health_changed = true

	_combo_score += sqrt(multiplier)
	_base_score += 1
	_is_score_changed = true
func add_miss():
	misses += 1

	max_combo = max(combo, max_combo)
	combo = 0
	_is_combo_changed = true

	if !failed:
		health = max(health - 8, 0)
		if health == 0: failed = true
		_is_health_changed = true

	multiplier = max(1, multiplier - 1)
	sub_multiplier = 0
	_is_multiplier_changed = true
	_is_score_changed = true

func flush():
	if _is_score_changed: score_changed.emit()
	if _is_multiplier_changed: multiplier_changed.emit()
	if _is_combo_changed: combo_changed.emit()
	if _is_health_changed: health_changed.emit()
