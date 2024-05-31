extends SyncManager
class_name AudioSyncManager

signal started_audio

@export var audio_player:AudioStreamPlayer

@export var audio_stream:AudioStream:
	get:
		return audio_stream
	set(value):
		if value != null: length = value.get_length()
		audio_stream = value
var time_delay:float = 0

func _set_offset():
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	audio_player.seek(real_time + time_delay)
func _start_audio():
	if audio_stream is AudioStreamMP3:
		audio_stream.loop = false
	if audio_stream is AudioStreamOggVorbis:
		audio_stream.loop = false
	if audio_stream is AudioStreamWAV:
		audio_stream.loop_mode = AudioStreamWAV.LOOP_DISABLED
	audio_player.stream = audio_stream
	audio_player.play(real_time)
	_set_offset()
	started_audio.emit(current_time)

func _process(delta:float):
	var can_play_audio = real_time >= 0 and playback_speed > 0 and real_time <= length
	var should_play_audio = can_play_audio and playing
	var is_playing_audio = audio_player.playing

	if should_play_audio and !is_playing_audio:
		_start_audio()
	if is_playing_audio and !should_play_audio:
		audio_player.stop()

	#if should_play_audio and is_playing_audio:
		#var difference = abs(audio_player.get_playback_position() - real_time)
		#if difference >= 0.1:
			#print("Resyncing (%sms)" % round(difference * 1000))
			#_set_offset()

	if playback_speed > 0:
		audio_player.pitch_scale = playback_speed
	
	super._process(delta)

func seek(from:float=0, real:bool=false):
	super.seek(from, real)
	_set_offset()

#func try_finish():
#	if (real_time - time_delay) > length:
#		finish()
