extends CharacterBody2D

@onready var dialogue_box = get_tree().get_first_node_in_group("dialogue_box")

var player_in_range: bool = false

func interact() -> void:
	var lines: Array[String] = [
		"Welcome to the village!",
		"Watch out for monsters in the forest to the north."
	]
	dialogue_box.start_dialogue("Village Guard", lines)


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false

func _unhandled_input(event: InputEvent) -> void:
	# Triggers when player is nearby, presses Space/Enter, and dialogue isn't already open
	if player_in_range and event.is_action_pressed("ui_accept") and not dialogue_box.is_active:
		get_viewport().set_input_as_handled()
		interact()
