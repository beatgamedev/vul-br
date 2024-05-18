extends Node

@onready var camera:Camera3D = $Camera
@onready var camera_pivot:Vector3 = camera.position
@onready var cursor:Node3D = $Cursor

var spin:bool = true
var drift:bool = true

var pitch:float = 0
var yaw:float = 0

var cursor_position:Vector2:
	get: return Vector2(
		clamp(real_cursor_position.x, -2.7375, 2.7375),
		clamp(real_cursor_position.y, -2.7375, 2.7375))
var real_cursor_position:Vector2 = Vector2.ZERO

func _do_spin():
	camera.rotation_degrees = Vector3(pitch, yaw, 0)
	real_cursor_position = Vector2(camera.position.x, camera.position.y) + Vector2(
		tan(camera.rotation.y),
		-tan(camera.rotation.x)
	) * -camera.position.z
func _do_lock():
	pass

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	var _cursor_position = self.cursor_position
	camera.position = (camera_pivot +
	(Vector3(_cursor_position.x, _cursor_position.y, 0) / 4) +
	(camera.basis.z / 2))
	if spin: _do_spin()
	else: _do_lock()
	_cursor_position = self.cursor_position
	cursor.position = Vector3(_cursor_position.x, _cursor_position.y, 0)

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_delta = event.relative
		if spin:
			pitch -= mouse_delta.y / 10
			yaw -= mouse_delta.x / 10
		else:
			real_cursor_position += mouse_delta * Vector2(1, -1) / 100
		if drift: real_cursor_position = self.cursor_position
