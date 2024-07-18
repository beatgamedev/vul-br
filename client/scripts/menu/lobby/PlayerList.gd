extends PanelContainer

@onready var list = $M/Content/S/Items
@onready var player_template = $M/Content/S/Items/Player

func _ready():
	list.remove_child(player_template)
	
	for peer in Online.players.keys():
		if Online.players[peer].awaiting_info: continue
		_player_added(peer, Online.players[peer])
	Online.player_added.connect(_player_added)
	#_player_added(Online.local_player.peer_id, Online.local_player)

func _player_added(peer: int, player: LobbyPlayer):
	var item = player_template.duplicate()
	item.get_node("M/H/Icons/Host").visible = peer == 1
	item.get_node("M/H/Label").text = player.display_name
	item.name = str(peer)
	list.add_child(item)
	print(peer)
