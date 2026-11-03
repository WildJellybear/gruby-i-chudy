extends Node2D
class_name Inventory

const ITEM_SLOT = preload("res://scenes/items/item_slot.tscn")

var inventory_row_size : int = 10
var inventory_col_size : int = 2
var inventory_items  = []

var is_visible = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(inventory_row_size):
		inventory_items.append([])
		
		for y in range(inventory_col_size):
			inventory_items[x].append([])
			
			var instance = ITEM_SLOT.instantiate()
			instance.global_position = Vector2(x * 50, y * 50)
			instance.slot_number = Vector2i(x, y)
			add_child(instance)
			inventory_items[x][y] = instance
			 
			
func prep_item(new_item):
	var item = {}
	
	item['name'] = new_item.item_res.name
	item['inv_icon'] = new_item.item_res.inv_icon
	item['stack_amount'] = new_item.item_res.stack_amount
	item['item_path'] = new_item.item_res.item_path
	
	return item
	
func add_item(item):
	for y in range(inventory_col_size):
		for x in range(inventory_row_size):
			var slot = inventory_items[x][y]
			
			if slot.add_item(item):
				return true
				
	return false
		
	
func toggle():
	is_visible = (! is_visible)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("i"):
		#toggle()
		
