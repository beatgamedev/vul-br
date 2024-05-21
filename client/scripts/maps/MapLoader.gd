class_name MapLoader

signal loading_maps(current:int, total:int, errors:int)
signal loaded_maps(maps:Array[Map])

var thread:Thread

var folders:Array[String] = []
func add_search_folder(path:String, recursive:bool=false):
	if !folders.has(path): folders.append(path)
	if recursive:
		for directory in DirAccess.get_directories_at(path):
			add_search_folder(directory, true)
func get_all_files() -> Array[String]:
	var files = []
	for folder in folders:
		if !DirAccess.dir_exists_absolute(folder): continue
		for file in DirAccess.get_files_at(folder):
			var full_file = folder.path_join(file) if file != file.get_file() else file
			if !files.has(full_file): files.append(full_file)
	return files

func _load_maps(files:Array[String] = get_all_files()):
	var maps = []
	
	var current = 0
	var total = files.size()
	var errors = 0
	
	for file in files:
		loading_maps.emit(current, total, errors)
		current += 1
		var map = SspmMap.new()
		if map.load_from_path(file) != OK:
			print("Error loading map %s" % file.get_file())
			errors += 1
	loading_maps.emit(current, total, errors)
	
	loaded_maps.emit(maps)
	return maps

func load_maps():
	if thread: thread.wait_to_finish()
	var files = get_all_files()
	thread = Thread.new()
	thread.start(_load_maps.bind(files))
	return thread
func load_maps_blocking():
	if thread:
		print("Maps are already loading, so we will wait and use them instead")
		return thread.wait_to_finish()
	return _load_maps()
