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

func comma_separate(number: int):
	var string = str(abs(number))
	var mod = string.length() % 3
	var result = ""
	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod: result += ","
		result += string[i]
	if number < 0: result = "-" + result
	return result
func seconds_to_timestamp(total_seconds: int):
	var minutes = abs(total_seconds) / 60
	var seconds = abs(total_seconds) % 60
	var result = "%d:%02d" % [minutes, seconds]
	if total_seconds < 0: result = "-" + result
	return result
