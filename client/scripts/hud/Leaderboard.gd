extends Control

@onready var item_container = self
@onready var template_item = $Player

var items:Dictionary = {}
@onready var ordered_players = Online.players.values()

func _order_items():
	ordered_players.sort_custom(func(a,b): return a.score > b.score)
	for i in ordered_players.size():
		var player = ordered_players[i]
		var item = items.get(player.peer_id)
		if item == null: break
		item_container.move_child(item, i)

func _ready():
	item_container.remove_child(template_item)
	#Online.player_added.connect(func(peer_id,player): _create_item(player))
	#Online.player_removed.connect(func(peer_id,player): _remove_item(peer_id))
	_create_items()

func _create_item(player:LobbyPlayer):
	var peer_id = player.peer_id
	var item = template_item.duplicate()
	item.name = str(peer_id)
	item.set_meta("player", player)
	items[peer_id] = item
	item_container.add_child(item)
	player.score_updated.connect(_update_item.bind(item))
	player.score_updated.connect(_order_items)
	_update_item(item)
	return item

func _create_items():
	var lobby_players = Online.players
	for player in lobby_players.values():
		_create_item(player)
	
func _update_item(item):
	var player:LobbyPlayer = item.get_meta("player")
	item.get_node("DisplayName").text = player.display_name
	item.get_node("H/Score").text = Globals.comma_separate(player.score)
	item.get_node("H/Combo").text = "x%s" % Globals.comma_separate(player.combo)
	item.get_node("Health").value = player.health

func _remove_item(peer_id:int):
	if !items.has(peer_id): return
	items.get(peer_id).queue_free()
	items.erase(peer_id)

func _process(delta):
	pass
