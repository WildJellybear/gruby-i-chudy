
extends Node2D

@onready var item_icon = $item_icon
@onready var item_count_label = $item_count_label

var slot_number: Vector2i
var item: InventoryItemData = null
var item_count: int = 0


func add_item(new_item: InventoryItemData) -> bool:
	if new_item.stack_amount <= 0:
		return false

	if item == null or (item.name == new_item.name and item_count < item.stack_amount):
		item_count += 1
		item = new_item
		item_icon.texture = item.inv_icon
		refresh_label()
		return true

	return false


func refresh_label() -> void:
	item_count_label.text = str(item_count)
