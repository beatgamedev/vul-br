extends Control

@onready var item_container = $S/M/V
@onready var template_item = $S/M/V/Player

var items:Dictionary = {}

func _ready():
	item_container.remove_child(template_item)
	
	Online.player_added.connect(func(peer_id,player): _create_item(player))
	Online.player_removed.connect(func(peer_id,player): _remove_item(peer_id))
	_create_items()

func _create_item(player:LobbyPlayer):
	var peer_id = player.peer_id
	var item = template_item.duplicate()
	item.name = str(peer_id)
	item.set_meta("player", player)
	items[peer_id] = player
	item_container.add_child(item)
	if peer_id == 1: item_container.move_child(item, 0)
	player.updated.connect(_update_item.bind(item))
	_update_item(item)
	return item
func _create_items():
	var lobby_players = Online.players
	for player in lobby_players.values():
		_create_item(player)
func _update_item(item):
	var player = item.get_meta("player")
	item.get_node("H/Info/PlayerName").text = player.display_name
	item.get_node("H/Info/Host").visible = player.peer_id == 1
func _remove_item(peer_id:int):
	if !items.has(peer_id): return
	items.get(peer_id).queue_free()
	items.erase(peer_id)
