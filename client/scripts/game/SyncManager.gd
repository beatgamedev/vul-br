extends Node
class_name SyncManager

signal started
signal finished

@export var playing:bool:
	get: return _playing
	set(value):
		if value: start()
		else: finish()
var _playing:bool = false
@export var playback_speed:float = 1

var last_time:int = 0
@export var real_time:float = 0
@export var current_time:float:
	get: return real_time + game_offset * playback_speed
	set(value): real_time = value - game_offset * playback_speed
var physics_offset:float = 0
var physics_time:float:
	get: return self.current_time + physics_offset
@export var length:float = 0

@onready var game_offset:float = 0

@export var parent_sync_manager:SyncManager

func start(from:float=current_time):
	_playing = true
	last_time = Time.get_ticks_usec()
	real_time = min(from - game_offset * playback_speed, from)
	started.emit(current_time)
func seek(from:float=0, real:bool=false):
	last_time = Time.get_ticks_usec()
	if !real: real_time = from - game_offset * playback_speed
	else: real_time = from
func finish():
	_playing = false
	finished.emit()

func _process(delta):
	if parent_sync_manager != null:
		_playing = parent_sync_manager.playing
		playback_speed = parent_sync_manager.playback_speed
		real_time = parent_sync_manager.real_time
		return
	if !playing: return
	physics_offset = 0
	var now = Time.get_ticks_usec()
	var time = playback_speed * min(now - last_time, 100000) / 1000000.0
	last_time = now
	real_time += time
	try_finish()
func _physics_process(delta):
	if !playing:
		physics_offset = 0
		return
#	physics_offset = (Time.get_ticks_usec() - last_time) / 1000000.0
	physics_offset += delta

func try_finish():
	if current_time > length:
		finish()
