extends Control

func _ready():
	if Online.in_lobby: switch_to_lobby()
	else: switch_to_lobbies()
	Online.connected.connect(switch_to_lobby)
	Online.disconnected.connect(switch_to_lobbies)

func switch_to_lobbies():
	$Tabs.current_tab = 0
	DiscordRPC.state = "In menu"
	DiscordRPC.details = "Looking for a lobby"
	DiscordRPC.refresh()
func switch_to_lobby():
	$Tabs.current_tab = 1
	DiscordRPC.state = "In lobby"
	DiscordRPC.details = "Looking for a map"
	DiscordRPC.refresh()
