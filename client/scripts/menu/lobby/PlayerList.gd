extends PanelContainer

@onready var list: VBoxContainer = $M/Content/S/Items
@onready var player_template: Control = $M/Content/S/Items/Player

func _ready() -> void:
	list.remove_child(player_template)
	
	for peer: int in Online.players.keys():
		if Online.players[peer].awaiting_info: continue
		_player_added(peer, Online.players[peer])
	Online.player_added.connect(_player_added)
	#_player_added(Online.local_player.peer_id, Online.local_player)

func _player_added(peer: int, player: LobbyPlayer) -> void:
	var item: Control = player_template.duplicate()
	item.get_node("M/H/Icons/Host").visible = peer == 1
	item.get_node("M/H/Label").text = player.display_name
	item.name = str(peer)
	list.add_child(item)

func _player_removed(peer: int, player: LobbyPlayer) -> void:
	list.get_node(str(peer)).queue_free()
