extends MultiMeshInstance3D

@export var game: Game
@export var sync_manager: SyncManager
@export var player: GamePlayer

var hit_window: float = 1.75/30

@onready var approach_distance: float = Vulnus.settings.get("approach_distance")
@onready var approach_time: float = Vulnus.settings.get("approach_time")

var notes: Array[Map.Note] = []
var next_note: int = 0
var current_notes: Array[Map.Note] = []

func _process(delta: float) -> void:
	var song_time: float = sync_manager.time
	var current_notes_size: int = current_notes.size()
	if current_notes_size > multimesh.instance_count: multimesh.instance_count = current_notes_size + 1
	multimesh.visible_instance_count = current_notes_size
	for i: int in current_notes_size:
		var note: Map.Note = current_notes[i]
		var time_difference: float = note.time - song_time
		var progress: float = time_difference / approach_time
		var inverse_progress: float = 1 - progress
		var distance: float = progress * approach_distance
		var position: Vector3 = Vector3(note.x, note.y, -distance)
		var transform: Transform3D = Transform3D.IDENTITY.translated(position)
		multimesh.set_instance_transform(i, transform)
		var color: Color = [Color.WHITE_SMOKE, Color.AQUA][note.index % 2]
		var fade_in: float = inverse_progress / 0.5
		color.a = clamp(fade_in, 0, 1)
		multimesh.set_instance_color(i, color)
func _physics_process(delta: float) -> void:
	var song_time: float = sync_manager.physics_time
	var cursor_position: Vector2 = player.cursor_position
	while next_note < notes.size():
		var note: Map.Note = notes[next_note]
		if note.time > song_time + approach_time: break
		current_notes.append(note)
		next_note += 1
	var hits: Array = []
	for note: Map.Note in current_notes:
		if song_time < note.time: break
		var aabb: float = max(
			abs(note.x - cursor_position.x),
			abs(note.y - cursor_position.y)
		)
		if aabb <= 1.1375:
			hits.append(note)
			game.score.add_hit(1)
	for note: Map.Note in hits:
		current_notes.erase(note)
	while current_notes.size() > 0:
		var note: Map.Note = current_notes[0]
		if song_time < note.time + hit_window: break
		game.score.add_miss()
		current_notes.pop_front()
	game.score.flush()
