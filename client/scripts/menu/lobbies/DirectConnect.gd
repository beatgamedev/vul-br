extends Control

@onready var ip = $IP

func join():
	$/root/Lobbies/M/Connecting.visible = true
	Online.join.call_deferred(ip.text)
func host():
	$/root/Lobbies/M/Connecting.visible = true
	Online.host.call_deferred()
