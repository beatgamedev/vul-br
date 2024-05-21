extends Node
class_name Game

var map:Map
var score:Score = Score.new()

func _ready():
	map.load_music()
	$AudioSyncManager.audio_stream = map.music
	map.load_notes()
	$Notes.notes = map.notes

	score._max_base_score = map.notes.size()
	for i in map.notes.size():
		score._max_combo_score += sqrt(clampi(floor((i+1)/10)+1, 1, 8))

	$AudioSyncManager.start.call_deferred(-1)
	$AudioSyncManager.finished.connect(get_tree().change_scene_to_file.bind("res://scenes/LobbyMenu.tscn"))

	$Preload.queue_free.call_deferred()
