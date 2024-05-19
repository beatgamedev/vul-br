extends MultiMeshInstance3D

@export var game:Game
@export var sync_manager:SyncManager

var approach_distance:float = 50
var approach_time:float = 0.75

var notes:Array[Map.Note] = []
var next_note:int = 0
var ignore_notes:Array[Map.Note] = [] # Notes that we already passed/hit/missed
var current_notes:Array[Map.Note] = [] # Notes that need to be processed

func _process(delta):
	var current_notes_size = current_notes.size()
	if current_notes_size > multimesh.instance_count: multimesh.instance_count = current_notes_size + 1
	multimesh.visible_instance_count = current_notes_size
	for i in current_notes_size:
		var note = current_notes[i]
		var time_difference = note.time - sync_manager.current_time
		var distance = (time_difference / approach_time) * approach_distance
		var position = Vector3(2 * (-note.x + 1), 2 * (-note.y + 1), -distance)
		var transform = Transform3D.IDENTITY.translated(position)
		multimesh.set_instance_transform(i, transform)
		multimesh.set_instance_color(i, Color.WHEAT)
func _physics_process(delta):
	while next_note < notes.size():
		var note = notes[next_note]
		if note.time > sync_manager.physics_time + approach_time: break
		current_notes.append(note)
		next_note += 1
