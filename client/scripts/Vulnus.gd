extends Node

var exe_path = OS.get_executable_path()

# Self Containment
@onready var is_self_contained:bool = check_self_contained()
func check_self_contained() -> bool: # Returns if the editor is self-contained
	return DirAccess.dir_exists_absolute(exe_path.path_join("appdata"))

# Command Line Arguments
var cl_arg_aliases:Dictionary = {}
@onready var cl_args:Dictionary = parse_cl_args()
func parse_cl_args() -> Dictionary: # Parses command line arguments
	var _args = OS.get_cmdline_args()

	var parsed_args = {}

	var i = 0
	var key = "root"
	var value = null

	while i < _args.size():
		var arg = _args[i]
		i += 1

		var arg_extends_value = false
		if value != null: arg_extends_value = value.ends_with("\\")
		var arg_is_key = arg.begins_with("-") and !arg_extends_value

		if key != null:
			if value == null and !arg_is_key: value = arg
			elif arg_extends_value: value = value.substr(0, value.length() - 1) + " " + arg
			else:
				if value != null and value.begins_with("\"") and value.ends_with("\""):
					value = value.substr(1, value.length() - 2)
				parsed_args[key] = value if value != null else true
				key = null
				value = null

		if key == null:
			if !arg_is_key:
				push_error("value with no key?")
				continue
			var stripped_arg = arg.trim_prefix("--")
			var arg_is_full = arg.begins_with("--")
			if !arg_is_full: stripped_arg = cl_arg_aliases.get(stripped_arg, stripped_arg)
			key = stripped_arg

	if key != null: parsed_args[key] = value if value != null else true

	for k in parsed_args.keys():
		print("%s=%s" % [k, parsed_args[k]])

	return parsed_args

# Path Conversion
var paths:Dictionary = {
	"settings file": "user://settings.json",
	"settings error file": "user://settings.json.old",
	"maps folder": "user://maps"
}
func find_path(id:String) -> String: # Gets paths from ids
	var path = paths.get(id, null)
	assert(path != null, "No path exists for id %s" % id)
	var expanded_path = expand_path(path)
	if !DirAccess.dir_exists_absolute(expanded_path.get_base_dir()):
		DirAccess.make_dir_recursive_absolute(expanded_path)
	return expanded_path
func expand_path(path:String) -> String: # Swaps out prefixes
	path = path.replace("exec:/", exe_path.get_base_dir())
	if is_self_contained and path.begins_with("user://"):
		path = path.replace("user:/", exe_path.get_base_dir())
	if path.begins_with("res://"):
		return path
	return ProjectSettings.globalize_path(path)

# Settings
var settings:Dictionary = {
	# Notes
	"approach_distance": 30,
	"approach_time": 1,
	# Gameplay
	"absolute_mode": false,
	"camera_lock": true,
	"sensitivity": 1,
	"drift": true,
	"parallax": 1,
	# Paths
	"map_folders": [],
	# Graphics
	"fullscreen": false,
	"vsync": false,
	"fps_limit": 300,
	# Multiplayer
	"nickname": "Player"
}
func update_settings():
	if settings.fullscreen: get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	else: get_window().mode = Window.MODE_WINDOWED
	if settings.vsync: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_MAILBOX)
	else: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	if settings.fps_limit < 15: settings.fps_limit = 0
	Engine.max_fps = settings.fps_limit
	Online.local_player_name = settings.nickname
func load_settings():
	var settings_path = find_path("settings file")
	if FileAccess.file_exists(settings_path):
		var text = FileAccess.get_file_as_string(settings_path)
		var json = JSON.new()
		json.parse(text)
		if json.get_error_line() != 0:
			push_warning(
				"Existing settings are broken\n- %s) %s" % [
				json.get_error_line(),
				json.get_error_message()
			])
			DirAccess.copy_absolute(settings_path, find_path("settings error file"))
			return
		var data = json.data
		for key in settings.keys():
			if data.keys().has(key):
				settings[key] = data[key]
	else:
		print("No existing settings")
	update_settings()
func save_settings():
	var settings_path = find_path("settings file")
	var file = FileAccess.open(settings_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(settings, " ", false, false))
	file.close()
	#print("Settings saved")
	update_settings()

# Maps
var maps:Array[Map] = []
var maps_by_id:Dictionary = {}

# Init
signal on_init_stage(text:String, stage:int, max_stage:int)
func _init_stage(text:String, stage:int, max_stage:int):
	on_init_stage.emit(text, stage, max_stage)
signal on_init_substage(text:String, stage:int, max_stage:int, substage:int, max_substage:int)
func _init_substage(text:String, stage:int, max_stage:int, substage:int, max_substage:int):
	on_init_substage.emit(text, stage, max_stage, substage, max_substage)
func _on_loading_maps(current:int, total:int, errors:int):
	_init_substage.call_deferred("Loading maps (%s/%s)" % [current, total], 0, 1, current, total)
signal on_init_finished()
func _init_finished():
	Globals.create_options_menu()
	on_init_finished.emit()
func init(): # This will run on another thread
	var stage = 0
	var max_stage = 1
	_init_stage.call_deferred("Waiting for engine", stage, max_stage)
	await get_tree().process_frame

	_init_stage.call_deferred("Loading maps", stage, max_stage)
	var map_loader = MapLoader.new()
	map_loader.add_search_folder(find_path("maps folder"))
	for folder in settings.map_folders:
		map_loader.add_search_folder(expand_path(folder))
	map_loader.loading_maps.connect(_on_loading_maps)
	var map_loader_thread = map_loader.load_maps()
	maps = await map_loader.loaded_maps
	map_loader_thread.wait_to_finish.call_deferred()
	for map in maps: maps_by_id[map.id] = map
	stage += 1

	_init_stage.call_deferred("Done", stage, max_stage)

	await get_tree().process_frame
	_init_finished.call_deferred()

func load_game(map_id:String):
	var map = maps_by_id.get(map_id)
	if map == null: return
	var game = preload("res://scenes/Game.tscn").instantiate()
	game.map = map
	return game

func _ready():
	load_settings()

	DiscordRPC.app_id = 1239676558587723819
	DiscordRPC.large_image = "icon"
	DiscordRPC.large_image_text = "Vulnus Battle Royale"
	DiscordRPC.details = "Loading"
	DiscordRPC.state = "Loading"
	DiscordRPC.refresh()

func _process(delta):
	DiscordRPC.run_callbacks()

func _exit_tree():
	save_settings()
