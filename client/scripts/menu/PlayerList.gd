extends Control

@export var item_container:Control
@export var template_item:Control

var items:Dictionary = {}

func _ready():
	item_container.remove_child(template_item)
	
	Online.player_added.connect(func(peer_id,_player): _create_item(peer_id))
	Online.player_removed.connect(func(peer_id,_player): _remove_item(peer_id))
	_create_items()

func _create_item(peer_id:int):
	var item = template_item.duplicate()
	item.name = peer_id
	item_container.add_child(item)
	return item
func _create_items():
	var lobby_players = Online.players
	for peer_id in lobby_players.keys():
		var item = _create_item(peer_id)
		item.set_meta("player", lobby_players.get(peer_id))
		_update_item(item)
		lobby_players.get(peer_id).updated.connect(_update_item.bind(item))
func _update_item(item):
	var player = item.get_meta("player")
	item.get_node("H/Info/PlayerName").text = player.display_name
	item.get_node("H/Info/Host").visible = player.peer_id == 1
func _remove_item(peer_id:int):
	if !items.has(peer_id): return
	items.get(peer_id).queue_free()
	items.erase(peer_id)
