extends Node

var options_menu:Control
func create_options_menu() -> void:
	if is_instance_valid(options_menu): return
	options_menu = preload("res://prefabs/options/Options.tscn").instantiate()
	add_sibling.call_deferred(options_menu)

func _process(delta: float) -> void:
	_background_noise(delta)

func change_scene(scene: Node) -> void:
	_change_scene.call_deferred(scene)
func _change_scene(scene: Node) -> void:
	get_tree().unload_current_scene()
	get_tree().root.add_child(scene)
	get_tree().current_scene = scene

func load_audio(file:PackedByteArray) -> AudioStream:
	var first4: PackedByteArray = file.slice(0, 4)
	if first4 == PackedByteArray([0x4f, 0x67, 0x67, 0x53]): # OggS
		print("OGG")
		return AudioStreamOggVorbis.load_from_buffer(file)
	elif first4 == PackedByteArray([0x52, 0x49, 0x46, 0x46]): # RIFF
		print("WAV")
		var stream: AudioStreamWAV = AudioStreamWAV.new()
		stream.data = file
		return stream
	else:
		print("UNKNOWN (assume MP3)")
		var stream: AudioStreamMP3 = AudioStreamMP3.new()
		stream.data = file
		return stream

func comma_separate(number: int) -> String:
	var string: String = str(abs(number))
	var mod: int = string.length() % 3
	var result: String = ""
	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod: result += ","
		result += string[i]
	if number < 0: result = "-" + result
	return result
func seconds_to_timestamp(total_seconds: int) -> String:
	var minutes: int = abs(total_seconds) / 60
	var seconds: int = abs(total_seconds) % 60
	var result: String = "%d:%02d" % [minutes, seconds]
	if total_seconds < 0: result = "-" + result
	return result

var noise_texture: NoiseTexture2D = preload("res://textures/BackgroundNoise.tres")
var _bg_noise_dir: float = 1
var _bg_noise_total: float = 0
var _bg_noise_real_total: float = 0
var _bg_noise_tween: Tween
func _background_noise(delta: float) -> void:
	var noise: Noise = noise_texture.noise
	_bg_noise_total += delta * _bg_noise_dir
	_bg_noise_real_total += delta
	if (_bg_noise_total * sign(_bg_noise_dir)) > 120 and abs(_bg_noise_dir) == 1: # after 2 minutes, then 4, then 4 ...
		_flip_background_noise()
	var rotation_offset: Vector3 = Vector3(
		sin(_bg_noise_real_total / 31.4) * 200.0,
		cos(_bg_noise_real_total / 31.4) * 400.0,
		0)
	noise.offset = Vector3(0, 0, _bg_noise_total * 10.0) + rotation_offset
func _flip_background_noise() -> void:
	if _bg_noise_tween: _bg_noise_tween.kill()
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "_bg_noise_dir", -sign(_bg_noise_dir), 10)
	_bg_noise_tween = tween
