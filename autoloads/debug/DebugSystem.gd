extends Node

func _ready() -> void:
	Events.start_player_chase.connect(func(e: Enemy): print(e, " is chasing player!"))
	Events.stop_player_chase.connect(func(e: Enemy): print(e, " stopped chasing player."))
