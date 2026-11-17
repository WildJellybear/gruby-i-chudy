
class_name InventoryItemData
extends RefCounted

var name: String
var inv_icon: Texture2D
var stack_amount: int
var item_path: String


func _init(source: Item) -> void:
	name = source.name
	inv_icon = source.inv_icon
	stack_amount = source.stack_amount
	item_path = source.item_path
