extends Node

func change_scene(scene:Node):
	_change_scene.call_deferred(scene)
func _change_scene(scene:Node):
	get_tree().unload_current_scene()
	get_tree().root.add_child(scene)
	get_tree().current_scene = scene

func load_audio(file:PackedByteArray) -> AudioStream:
	var first4 = file.slice(0, 4)
	if first4 == PackedByteArray([0x4f, 0x67, 0x67, 0x53]): # OggS
		print("OGG")
		return AudioStreamOggVorbis.load_from_buffer(file)
	elif first4 == PackedByteArray([0x52, 0x49, 0x46, 0x46]): # RIFF
		print("WAV")
		var stream = AudioStreamWAV.new()
		stream.data = file
		return stream
	else:
		print("UNKNOWN (assume MP3)")
		var stream = AudioStreamMP3.new()
		stream.data = file
		return stream

func comma_separate(number: int) -> String:
	var string = str(abs(number))
	var mod = string.length() % 3
	var result = ""
	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod: result += ","
		result += string[i]
	if number < 0: result = "-" + result
	return result
func seconds_to_timestamp(total_seconds: int) -> String:
	var minutes = abs(total_seconds) / 60
	var seconds = abs(total_seconds) % 60
	var result = "%d:%02d" % [minutes, seconds]
	if total_seconds < 0: result = "-" + result
	return result
