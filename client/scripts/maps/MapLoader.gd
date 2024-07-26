class_name MapLoader

signal loading_maps(current: int, total: int, errors: int)
signal loaded_maps(maps: Array[Map])

var thread: Thread

var folders: Array[String] = []
func add_search_folder(path: String, recursive: bool=false) -> void:
	if !folders.has(path): folders.append(path)
	if recursive:
		for directory in DirAccess.get_directories_at(path):
			add_search_folder(directory, true)
func get_all_files() -> Array[String]:
	var files:Array[String] = []
	for folder in folders:
		if !DirAccess.dir_exists_absolute(folder): continue
		for file in DirAccess.get_files_at(folder):
			var full_file: String = folder.path_join(file) if file == file.get_file() else file
			if !files.has(full_file): files.append(full_file)
	return files

func _load_maps(files:Array[String] = get_all_files()) -> Array[Map]:
	var maps: Array[Map] = []
	
	var current: int = 0
	var total: int = files.size()
	var errors: int = 0
	
	for file in files:
		loading_maps.emit(current, total, errors)
		current += 1
		var map: Map = SspmMap.new()
		var error: Error = map.load_from_path(file)
		if error != OK:
			print("Error %s loading map %s" % [error, file])
			errors += 1
		else: maps.append(map)
	loading_maps.emit(current, total, errors)
	
	loaded_maps.emit(maps)
	return maps

func load_maps() -> Thread:
	if thread: thread.wait_to_finish()
	var files: Array[String] = get_all_files()
	thread = Thread.new()
	thread.start(_load_maps.bind(files))
	return thread
func load_maps_blocking() -> Array[Map]:
	if thread:
		print("Maps are already loading, so we will wait and use them instead")
		return thread.wait_to_finish()
	return _load_maps()
