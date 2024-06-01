extends Control
class_name IngamePlayerList

@onready var item_container = $"."
@onready var template_item = $Player

@onready var health_progress = $Player/Health

@export var game:Game

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
	player.score_updated.connect(_update_player.bind(item))
	_update_item(item)
	return item

func _create_items():
	var lobby_players = Online.players
	for player in lobby_players.values():
		_create_item(player)
	
func _update_item(item):
	var player:LobbyPlayer = item.get_meta("player")
	item.get_node("DisplayName").text = player.display_name
	item.get_node("H/Score").text = "0"
	item.get_node("H/Combo").text = "x0"
	item.get_node("Health").value = 40
	
func _update_player(id_, item):
	var player:LobbyPlayer = item.get_meta("player")
	if player.score_updated:
		item.get_node("H/Score").text = str(player.score)
		item.get_node("H/Combo").text = "x" + str(player.combo)
		item.get_node("Health").value = player.health

func _remove_item(peer_id:int):
	if !items.has(peer_id): return
	items.get(peer_id).queue_free()
	items.erase(peer_id)

func _process(delta):
	pass
