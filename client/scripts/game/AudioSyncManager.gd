extends SyncManager
class_name AudioSyncManager
## SyncManager that connects to an [AudioStreamPlayer].

@export var audio_player: AudioStreamPlayer ## The [AudioStreamPlayer] to connect to.
@export var stream: AudioStream: ## The [AudioStream] to play.
	get: return null if audio_player == null else audio_player.stream
	set(value): if audio_player != null: audio_player.stream = value

var _audio_delay: float = 0 # The delay of the audio in seconds.

func _set_audio_offset() -> void: # Sets the internal offset to the audio offset.
	_audio_delay = AudioServer.get_time_to_next_mix()
	#if _audio_delay < 0: _audio_delay = AudioServer.get_time_since_last_mix()
	_internal_offset = _audio_delay
	offset = -AudioServer.get_output_latency() 

func _play_audio(from_time: float) -> void:
	_set_audio_offset()
	audio_player.play(from_time)

func _sync_audio_player() -> void: # Syncs the AudioStreamPlayer to the SyncManager.
	var sync_playing: bool = playing
	var audio_playing: bool = audio_player.playing
	var audio_can_play: bool = _real_time >= 0 and _real_time <= stream.get_length()
	if audio_playing and not (sync_playing and audio_can_play):
		audio_player.stop()
	if sync_playing and not audio_playing:
		if audio_can_play: _play_audio(_real_time)

var _last_audio_time_hardware: float = 0
var _audio_stream_sync_flags: int = 0
func _sync_audio_stream() -> void: # Ensures the SyncManager and AudioStream remain synced.
	if not audio_player.playing: return
	var audio_time_hardware: float = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()
	if audio_time_hardware < _last_audio_time_hardware: # This happens a lot and needs to be ignored.
		#print("Hardware rewinded %sms" % [ceil((_last_audio_time_hardware - audio_time_hardware) * 10000) / 10])
		return
	_last_audio_time_hardware = audio_time_hardware
	var time_difference: float = (time - offset) - audio_time_hardware
	var abs_difference: float = abs(time_difference)
	if time_difference >= 0.02: # It's normal to be a bit ahead
		print("Ahead of hardware by %sms" % [ceil(abs_difference * 10000) / 10])
		_audio_stream_sync_flags += 1
	elif time_difference <= -0.02: # It's less normal to be behind
		print("Behind hardware by %sms" % [ceil(abs_difference * 10000) / 10])
		_audio_stream_sync_flags += 1
	elif abs_difference < 0.1:
		_audio_stream_sync_flags = 0
	if abs_difference >= 0.1 and _audio_stream_sync_flags >= 2: # Something went really wrong here
		print("Over 100ms! This is really bad, attempting to resync")
		_set_audio_offset()
		print("New offset: %sms" % [ceil(_internal_offset * 10000) / 10])
	if abs_difference >= 0.01 and _audio_stream_sync_flags >= 5: # Something went wrong
		print("Over 10ms for 5 frames! Attempting to compensate")
		_internal_offset -= time_difference
		print("New offset: %sms" % [ceil(_internal_offset * 10000) / 10])
		return

var _last_stream_sync: int = 0
func _process(delta: float) -> void:
	super._process(delta)
	_sync_audio_player()
	if not playing: return
	if _now_usecs - _last_stream_sync < 500_000: return # 0.5s
	_sync_audio_stream()
	_last_stream_sync = _now_usecs
