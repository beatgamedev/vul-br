extends Node
class_name Game

var map: Map
var score: Score = Score.new()

func _ready() -> void:
	map.load_music()
	$AudioSyncManager.stream = map.music
	
	map.load_notes()
	$Notes.notes = map.notes

	score._max_base_score = map.notes.size()
	for i in map.notes.size():
		score._max_combo_score += sqrt(clampi(floor((i+1)/10)+1, 1, 8))

	$AudioSyncManager.play(-1)
	#$AudioSyncManager.finished.connect(get_tree().change_scene_to_file.bind("res://scenes/Lobby.tscn"))

	$Preload.queue_free.call_deferred()

	DiscordRPC.details = "%s [%s]" % [map.title, map.difficulty]
	var player_count: int = Online.players.size() - 1
	var playing_message: String = "Playing with %s others" % player_count
	if player_count == 0: playing_message = "Playing alone"
	elif player_count == 1: playing_message = "Playing 1v1"
	DiscordRPC.state = playing_message
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system()) + 1
	#DiscordRPC.end_timestamp = DiscordRPC.start_timestamp + int($AudioSyncManager)
	DiscordRPC.refresh()

	score.score_changed.connect(_replicate_score)
	#score.combo_changed.connect(_replicate_score)

func _replicate_score() -> void:
	Online.local_player.update_score.rpc(score.score, score.combo, score.health)

func _exit_tree() -> void:
	DiscordRPC.start_timestamp = 0
	DiscordRPC.end_timestamp = 0
