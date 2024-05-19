extends Node
class_name Game

var map:Map
var score:Score = Score.new()

func _ready():
	map.load_music()
	$AudioSyncManager.audio_stream = map.music
	map.load_notes()
	$Notes.notes = map.notes

	$AudioSyncManager.start.call_deferred(-1)

	$Preload.queue_free.call_deferred()
