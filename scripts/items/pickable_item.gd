extends Node2D

@export var item_res : Item
@export var inv = Inventory
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if inv.add_item(inv.prep_item(self)):
			queue_free()
