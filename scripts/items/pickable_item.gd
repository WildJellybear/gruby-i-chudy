extends Node2D

@export var item_res: Item
@export var inv = Inventory


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		pick_up()


func _on_area_2d_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
) -> void:
	if event.is_action_pressed("pick_up_item"):
		pick_up()


func pick_up() -> void:
	if inv.add_item(inv.prep_item(self)):
		queue_free()
