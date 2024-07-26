extends Node
class_name SyncManager
## Base class for handling anything that requires syncing.

var _playing: bool = false # Internal playing value.
@export var playing: bool = false:
	get: return _playing
	set(value):
		if value and not _playing: play(time)
		if _playing and not value: pause()
		_playing = value
@export var time: float: ## The current time in seconds of the SyncManager. Offset is applied here.
	get: return _real_time + _internal_offset + offset
	set(value): seek(value)
var time_msecs: int: ## The current time in milliseconds of the SyncManager. Offset is applied here.
	get: return int(time * 1000)
var physics_time: float: ## The current time in seconds of the SyncManager. Offset is applied here. (calculated on physics loop)
	get: return _real_physics_time + _internal_offset + offset
	set(value): push_error("Can't set physics_time on AudioSyncManager")
var physics_time_msecs: int: ## The current time in milliseconds of the SyncManager. Offset is applied here. (calculated on physics loop)
	get: return int(physics_time * 1000)

var _real_time: float = 0 # The internal time value.
var _real_physics_time: float = 0 # The internal physics time value.
var _start_time: int = 0 # The internal start value for calculating time. Time.get_ticks_usec()

var _internal_offset: float = 0 # Internal offset to be applied by other classes.
@export var offset: float = 0 ## Offset (seconds) to apply to [member time].

@export var sync_parent: SyncManager ## Optional SyncManager for this one to copy.

func play(from_time: float = 0) -> void: ## Start playing from a time (seconds).
	if sync_parent != null: return # Can't manually play with a parent.
	seek(from_time)
	_playing = true

func pause() -> void: ## Stop playing temporarily.
	if sync_parent != null: return # Can't manually stop with a parent.
	_playing = false

func stop() -> void: ## Stop playing and reset time to 0.
	if sync_parent != null: return # Can't manually stop with a parent.
	pause()
	seek(0)

func seek(new_time: float) -> void: ## Seek to a time (seconds).
	if sync_parent != null: return # Can't manually seek with a parent.
	var new_real_time: float = new_time - (_internal_offset + offset)
	var new_time_usecs: int = int(new_real_time * 1_000_000)
	_start_time = Time.get_ticks_usec() - new_time_usecs
	if not playing: _real_time = new_real_time

func seek_no_offset(new_real_time: float) -> void: ## Seek to a time (seconds) without considering offset.
	if sync_parent != null: return # Can't manually seek with a parent.
	var new_time_usecs: int = int(new_real_time * 1_000_000)
	_start_time = Time.get_ticks_usec() - new_time_usecs
	if not playing: _real_time = new_real_time

func _copy_parent() -> void: # Syncs to the sync_parent.
	playing = sync_parent.playing
	_real_time = sync_parent._real_time

var _now_usecs: int = 0 # Current time used in process, outside for other classes
func _process(delta: float) -> void:
	if sync_parent != null: return _copy_parent()
	if not playing: return
	_now_usecs = Time.get_ticks_usec()
	_real_time = float(_now_usecs - _start_time) / 1_000_000.0

func _physics_process(delta: float) -> void:
	if not playing:
		_real_physics_time = _real_time
		return
	var now_usecs: int = Time.get_ticks_usec()
	_real_physics_time = float(now_usecs - _start_time) / 1_000_000.0
