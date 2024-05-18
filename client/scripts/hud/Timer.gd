extends Node

@export var game:Game
@export var sync_manager:SyncManager

@onready var song_label = $SubViewport/Control/SongTitle
@onready var start_label = $SubViewport/Control/Timer/Start
@onready var end_label = $SubViewport/Control/Timer/End
@onready var progress_bar = $SubViewport/Control/Progress

func _ready():
	pass

func _process(delta):
	start_label.text = Vulnus.seconds_to_timestamp(sync_manager.real_time)
	end_label.text = Vulnus.seconds_to_timestamp(sync_manager.length)
	progress_bar.max_value = sync_manager.length
	progress_bar.value = sync_manager.real_time
