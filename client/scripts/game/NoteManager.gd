extends MultiMeshInstance3D

@export var game:Game
@export var sync_manager:SyncManager
@export var player:GamePlayer

var hit_window = 1.75/30

@onready var approach_distance:float = Vulnus.settings.get("approach_distance")
@onready var approach_time:float = Vulnus.settings.get("approach_time")

var notes:Array[Map.Note] = []
var next_note:int = 0
var current_notes:Array[Map.Note] = []

func _process(delta):
	var current_notes_size = current_notes.size()
	if current_notes_size > multimesh.instance_count: multimesh.instance_count = current_notes_size + 1
	multimesh.visible_instance_count = current_notes_size
	for i in current_notes_size:
		var note = current_notes[i]
		var time_difference = note.time - sync_manager.current_time
		var distance = (time_difference / approach_time) * approach_distance
		var position = Vector3(note.x, note.y, -distance)
		var transform = Transform3D.IDENTITY.translated(position)
		multimesh.set_instance_transform(i, transform)
		multimesh.set_instance_color(i, [Color.WHITE_SMOKE, Color.AQUA][note.index % 2])
func _physics_process(delta):
	while next_note < notes.size():
		var note = notes[next_note]
		if note.time > sync_manager.physics_time + approach_time: break
		current_notes.append(note)
		next_note += 1
	var hits = []
	for note in current_notes:
		if sync_manager.physics_time < note.time: break
		var aabb = max(
			abs(note.x - player.cursor_position.x),
			abs(note.y - player.cursor_position.y)
		)
		if aabb <= 1.1375:
			hits.append(note)
			game.score.add_hit(1)
	for note in hits:
		current_notes.erase(note)
	while current_notes.size() > 0:
		var note = current_notes[0]
		if sync_manager.physics_time < note.time + hit_window: break
		game.score.add_miss()
		current_notes.pop_front()
