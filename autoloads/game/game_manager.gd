extends Node

var player: Player = null:
	set(p):
		player = p
		Events.player_changed.emit(p)
