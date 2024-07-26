class_name Map # Inherited by other map formats

signal cover_loaded
signal music_loaded
signal notes_loaded

var path: String
var broken: bool = false

var id: String
var title: String
var mappers: Array[String] = []
var mappers_string: String:
	get:
		var result: String = ""
		for i in mappers.size():
			if i != 0: result += ", "
			result += mappers[i]
		return result
var difficulty: String
func load_metadata() -> void: pass

var cover: Texture2D = preload("res://images/cover.png")
func load_cover() -> void: pass
var music: AudioStream
func load_music() -> void: pass
var notes: Array[Note]
func load_notes() -> void: pass

class Note:
	var index: int = 0
	var time: float = 0
	var x: float = 0
	var y: float = 0

func load_from_path(path: String) -> Error:
	self.path = path
	if !FileAccess.file_exists(Vulnus.expand_path(path)): return ERR_FILE_NOT_FOUND
	return _load_from_file()
func _load_from_file() -> Error:
	return ERR_BUG
