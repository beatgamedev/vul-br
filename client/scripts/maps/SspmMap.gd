extends Map
class_name SspmMap

const Difficulties = ["N/A", "Easy", "Medium", "Hard", "Logic", "Tasukete"]

var sspm_version:int = 1
# v1 + v2
var _note_count:int = 0
var _has_cover:bool = true
var _cover_offset:int = 0
var _music_offset:int = 0
var _music_length:int = 0
var _notes_offset:int = 0
# v2
var _cover_length:int = 0
var _marker_count:int = 0
var _marker_def_offset:int = 0
var _markers_offset:int = 0

func load_metadata(file:FileAccess=null):
	if file == null: file = FileAccess.open(path, FileAccess.READ)
	file.seek(10)
	if sspm_version == 1:
		id = file.get_line()
		title = file.get_line()
		mappers = [file.get_line()]
		file.seek(file.get_position() + 4)
		_note_count = file.get_32()
		difficulty = Difficulties[file.get_8()]
		_cover_offset = file.get_position()
		match file.get_8():
			1:
				file.seek(_cover_offset + 6)
				file.seek(_cover_offset + 14 + file.get_64())
			2:
				file.seek(_cover_offset + 8 + file.get_64())
			_: _has_cover = false
		if file.get_8() != 1:
			broken = true
			return
		_music_offset = file.get_position()
		_music_length = file.get_64()
		file.seek(_music_offset + _music_length)
		_notes_offset = file.get_position()
	elif sspm_version == 2:
		file.seek(0x26)
		_marker_count = file.get_32()
		difficulty = Difficulties[file.get_8()]
		file.seek(file.get_position() + 2)
		if !bool(file.get_8()):
			broken = true
			return
		_has_cover = bool(file.get_8())
		file.seek(0x40)
		_music_offset = file.get_64()
		_music_length = file.get_64()
		_cover_offset = file.get_64()
		_cover_length = file.get_64()
		_marker_def_offset = file.get_64()
		file.seek(0x70)
		_markers_offset = file.get_64()
		file.seek(0x80)
		id = file.get_buffer(file.get_16()).get_string_from_utf8()
		title = file.get_buffer(file.get_16()).get_string_from_utf8()
		file.seek(file.get_position() + 2 + file.get_16())
		var creators = file.get_16()
		for i in range(creators):
			mappers.append(file.get_buffer(file.get_16()).get_string_from_utf8())
		for i in range(file.get_16()):
			var key_length = file.get_16()
			var key = file.get_buffer(key_length).get_string_from_utf8()
			var value = _read_data_type(file)
			if key == "difficulty_name" and typeof(value) == TYPE_STRING:
				difficulty = str(value)

func load_cover():
	if !_has_cover: return
	var file = FileAccess.open(path, FileAccess.READ)
	file.seek(_cover_offset)
	if sspm_version == 1:
		match file.get_8():
			1:
				var height = file.get_16()
				var width = file.get_16()
				var mipmaps = bool(file.get_8())
				var format = file.get_8()
				var length = file.get_64()
				var image = Image.create_from_data(width,height,mipmaps,format,file.get_buffer(length))
				cover.set_image(image)
			2:
				var image = Image.new()
				var length = file.get_64()
				image.load_png_from_buffer(file.get_buffer(length))
				cover.set_image(image)
	elif sspm_version == 2:
		var image = Image.new()
		image.load_png_from_buffer(file.get_buffer(_cover_length))
		cover.set_image(image)
func load_music():
	if broken: return
	var file = FileAccess.open(path, FileAccess.READ)
	file.seek(_music_offset)
	music = Globals.load_audio(file.get_buffer(_music_length))
func load_notes():
	if broken: return
	notes = []
	var file = FileAccess.open(path, FileAccess.READ)
	if sspm_version == 1:
		file.seek(_notes_offset)
		for i in range(_note_count):
			var note = Note.new()
			note.time = float(file.get_32())/1000
			if file.get_8() == 1:
				note.x = 2 * (-file.get_float() + 1)
				note.y = 2 * (-file.get_float() + 1)
			else:
				note.x = 2 * (-float(file.get_8()) + 1)
				note.y = 2 * (-float(file.get_8()) + 1)
			notes.append(note)
	elif sspm_version == 2:
		file.seek(_marker_def_offset)
		var markers = {}
		var types = []
		for _i in range(file.get_8()):
			var type = []
			types.append(type)
			type.append(file.get_buffer(file.get_16()).get_string_from_utf8())
			markers[type[0]] = []
			var count = file.get_8()
			for _o in range(1,count+1):
				type.append(file.get_8())
			file.get_8()
		file.seek(_markers_offset)
		for _i in range(_marker_count):
			var marker = []
			var ms = file.get_32()
			marker.append(ms)
			var type_id = file.get_8()
			var type = types[type_id]
			for i in range(1,type.size()):
				var data_type = type[i]
				var v = _read_data_type(file,true,false,data_type)
				marker.append_array([data_type,v])
			markers[type[0]].append(marker)
		if !markers.has("ssp_note"):
			broken = true
			return
		for note_data in markers.get("ssp_note"):
			if note_data[1] != 7: continue
			var note = Map.Note.new()
			note.time = float(note_data[0])/1000
			note.x = 2 * (-note_data[2].x + 1)
			note.y = 2 * (-note_data[2].y + 1)
			notes.append(note)
func _read_data_type(file:FileAccess,skip_type:bool=false,skip_array_type:bool=false,type:int=0,array_type:int=0):
	if !skip_type:
		type = file.get_8()
	match type:
		1: return file.get_8()
		2: return file.get_16()
		3: return file.get_32()
		4: return file.get_64()
		5: return file.get_float()
		6: return file.get_real()
		7:
			var value:Vector2
			var t = file.get_8()
			if t == 0:
				value = Vector2(file.get_8(),file.get_8())
				return value
			value = Vector2(file.get_float(),file.get_float())
			return value
		8: return file.get_buffer(file.get_16())
		9: return file.get_buffer(file.get_16()).get_string_from_utf8()
		10: return file.get_buffer(file.get_32())
		11: return file.get_buffer(file.get_32()).get_string_from_utf8()
		12:
			if !skip_array_type:
				array_type = file.get_8()
			var array = []
			array.resize(file.get_16())
			for i in range(array.size()):
				array[i] = _read_data_type(file,true,false,array_type)
			return array

func _load_from_file() -> Error:
	var file = FileAccess.open(path, FileAccess.READ)
	if file.get_buffer(4) != PackedByteArray([0x53, 0x53, 0x2b, 0x6d]): # SS+m
		return ERR_INVALID_DATA
	sspm_version = file.get_16()
	if sspm_version > 2: return ERR_PRINTER_ON_FIRE
	load_metadata(file)
	file.close()
	return OK