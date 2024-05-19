extends Control

@onready var join_address = $V/JoinAddress
@onready var connect_button = $V/Connect
@onready var host_port = $V/HostPort
@onready var host_button = $V/Host

func _ready():
	connect_button.pressed.connect(join)
	host_button.pressed.connect(host)

func join():
	_set_inputs(false)
	Online.join()
func host():
	_set_inputs(false)
	Online.host()

func _set_inputs(editable:bool):
	join_address.editable = editable
	connect_button.disabled = !editable
	host_port.editable = editable
	host_button.disabled = !editable
