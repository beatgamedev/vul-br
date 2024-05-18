extends Node

func _ready():
	DiscordRPC.app_id = 1239676558587723819
	DiscordRPC.large_image = "icon"
	DiscordRPC.large_image_text = "Vulnus Brasil"
	DiscordRPC.details = "Getting ready to ball out"
	DiscordRPC.state = "Loading"

	DiscordRPC.refresh()

func _process(delta):
	DiscordRPC.run_callbacks()

