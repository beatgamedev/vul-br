extends Node
class_name GamePlayer

@onready var camera:Camera3D = $Camera
@onready var camera_pivot:Vector3 = camera.position
@onready var cursor:Node3D = $Cursor

var spin:bool = false
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
	var look = camera.basis.z
	real_cursor_position = Vector2(camera.position.x, camera.position.y) - Vector2(
		look.x,
		look.y
	) * abs(camera.position.z / look.z)
	if drift: real_cursor_position = self.cursor_position
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
			pitch = wrap(pitch - mouse_delta.y / 10, -180, 180)
			if abs(pitch) < 90: yaw = wrap(yaw - mouse_delta.x / 10, -180, 180)
			else: yaw = wrap(yaw + mouse_delta.x / 10, -180, 180)
		else:
			real_cursor_position += mouse_delta * Vector2(1, -1) / 100
			if drift: real_cursor_position = self.cursor_position