extends Node

func load_audio(file:PackedByteArray) -> AudioStream:
	var first4 = file.slice(0, 4)
	var first3 = file.slice(0, 3)
	var first2 = file.slice(0, 2)
	if first4 == PackedByteArray([0x4f, 0x67, 0x67, 0x53]): # OggS
		return AudioStreamOggVorbis.load_from_buffer(file)
	elif (
		first3 == PackedByteArray([0x49, 0x44, 0x33]) or
		first2 == PackedByteArray([])
	):
		var stream = AudioStreamMP3.new()
		stream.data = file
		return stream
	else:
		var stream = AudioStreamWAV.new()
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
