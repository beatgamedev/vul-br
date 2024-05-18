extends Node
class_name Game

var score:Score = Score.new()

func _ready():
	$Preload.queue_free.call_deferred()
