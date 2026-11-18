extends Node2D

@export var item_res : Item
@export var inv = Inventory
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if inv.add_item(inv.prep_item(self)):
			queue_free()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Sprawdzamy, czy to konkretnie wciśnięcie lewego przycisku myszy
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		# Dodajemy przedmiot i usuwamy go ze sceny
		if inv.add_item(inv.prep_item(self)):
			queue_free()
