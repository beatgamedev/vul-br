extends Control

@onready var ip: LineEdit = $IP

func join() -> void:
	$/root/Lobbies/M/Connecting.visible = true
	Online.join.call_deferred(ip.text)
func host() -> void:
	$/root/Lobbies/M/Connecting.visible = true
	Online.host.call_deferred()
