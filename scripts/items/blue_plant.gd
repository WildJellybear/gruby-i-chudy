extends Node2D

@export var item_res : Item
@onready var inv = GlobalUI.get_node("Control/global-inventory")

	
func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body.name == "player":
	if body.is_in_group("playable_characters"):
		if inv.add_item(inv.prep_item(self)):
			queue_free()
