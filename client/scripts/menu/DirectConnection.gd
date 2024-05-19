extends Control

@onready var join_address = $V/Server/Address
@onready var join_port = $V/Server/Port
@onready var connect_button = $V/Connect
@onready var host_port = $V/HostPort
@onready var host_button = $V/Host

func _ready():
	connect_button.pressed.connect(join)
	host_button.pressed.connect(host)

func join():
	_set_inputs(false)
	var address:String = join_address.text
	if address.is_empty(): address = join_address.placeholder_text
	var port:String = join_port.text
	if port.is_empty(): port = join_port.placeholder_text
	if Online.join(address, int(port)) == OK: get_tree().change_scene_to_file.call_deferred("res://scenes/LobbyMenu.tscn")
	else: _set_inputs(true)
func host():
	_set_inputs(false)
	var port:String = host_port.text
	if port.is_empty(): port = host_port.placeholder_text
	if Online.host(int(port)) == OK: get_tree().change_scene_to_file.call_deferred("res://scenes/LobbyMenu.tscn")
	else: _set_inputs(true)
func _set_inputs(editable:bool):
	join_address.editable = editable
	join_port.editable = editable
	connect_button.disabled = !editable
	host_port.editable = editable
	host_button.disabled = !editable
