extends Node

@export var sync_manager:SyncManager

@onready var start_label = $SubViewport/Control/Timer/Start
@onready var end_label = $SubViewport/Control/Timer/End
@onready var progress_bar = $SubViewport/Control/Progress

func _process(delta):
	start_label.text = Vulnus.seconds_to_timestamp(sync_manager.real_time)
	end_label.text = Vulnus.seconds_to_timestamp(sync_manager.length)
	progress_bar.max_value = sync_manager.length
	progress_bar.value = sync_manager.real_time