extends VBoxContainer

@onready var item_container: VBoxContainer = self
@onready var template_item: Control = $Player

var items: Dictionary = {}
@onready var ordered_players: Array = Online.players.values()

func _order_items() -> void:
	ordered_players.sort_custom(func(a: LobbyPlayer, b: LobbyPlayer) -> bool: return a.score > b.score)
	for i: int in ordered_players.size():
		var player: LobbyPlayer = ordered_players[i]
		var item: Control = items.get(player.peer_id)
		if item == null: break
		item.get_node("Placement").text = "#%s" % [i + 1]
		item_container.move_child(item, i)

func _ready() -> void:
	item_container.remove_child(template_item)
	_create_items()

func _create_item(player: LobbyPlayer) -> Control:
	var peer_id: int = player.peer_id
	var item: Control = template_item.duplicate()
	item.name = str(peer_id)
	item.set_meta("player", player)
	items[peer_id] = item
	item_container.add_child(item)
	player.score_updated.connect(_update_item.bind(item))
	player.score_updated.connect(_order_items)
	_update_item(item)
	return item

func _create_items() -> void:
	var lobby_players: Dictionary = Online.players
	for player: LobbyPlayer in lobby_players.values():
		_create_item(player)
	
func _update_item(item: Control) -> void:
	var player: LobbyPlayer = item.get_meta("player")
	item.get_node("DisplayName").text = player.display_name
	item.get_node("H/Score").text = Globals.comma_separate(player.score)
	item.get_node("H/Combo").text = "x%s" % Globals.comma_separate(player.combo)
	item.get_node("Health").value = player.health

func _remove_item(peer_id: int) -> void:
	if !items.has(peer_id): return
	items.get(peer_id).queue_free()
	items.erase(peer_id)

func _process(delta: float) -> void:
	pass
