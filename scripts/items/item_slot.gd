extends Node2D

@onready var item_icon = $item_icon
@onready var item_count_label = $item_count_label

var slot_number : Vector2i
var item : Dictionary
var item_count : int = 0


func add_item(new_item):
	if(item_count != 0 and item['name'] == new_item['name'] and item_count < new_item['stack_amount']) or item == {}:
		item_count += 1
		item = new_item
		item_icon.texture = item['inv_icon']
		refresh_label()
		return true
	return false
	
func refresh_label():
	item_count_label.text = str(item_count)
