extends Button

var map:Map

func _ready() -> void:
	if map == null: return

	map.cover_loaded.connect(_update_cover)

	_update_cover()
	_update_meta()

func _update_cover() -> void:
	$Cover/Image.texture = map.cover

func _update_meta() -> void:
	$M/V/Title.text = map.title
	$M/V/H/Mapper.text = map.mappers_string
	$M/V/H/Difficulty.text = map.difficulty
