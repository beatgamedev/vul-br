extends Node

@export var game: Game
@export var sync_manager: SyncManager

@onready var song_label: Label = $SubViewport/Control/SongTitle
@onready var start_label: Label = $SubViewport/Control/Timer/Start
@onready var end_label: Label = $SubViewport/Control/Timer/End
@onready var progress_bar: ProgressBar = $SubViewport/Control/Timer/Progress

func _ready() -> void:
	song_label.text = "%s [%s]" % [game.map.title, game.map.difficulty]

#func _process(delta: float) -> void:
	##start_label.text = Globals.seconds_to_timestamp(sync_manager.time)
	##end_label.text = Globals.seconds_to_timestamp(sync_manager.player.length)
	##progress_bar.max_value = sync_manager.length
	#progress_bar.value = sync_manager.real_time
