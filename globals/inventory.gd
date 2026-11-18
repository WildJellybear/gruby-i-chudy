extends Node2D
# class_name Inventory

const ITEM_SLOT = preload("res://scenes/items/item_slot.tscn")


var inventory_row_size: int = 10
var inventory_col_size: int = 2
var inventory_items: Array = []
var slots_by_item_name: Dictionary = {}
var empty_slots: Array = []
var is_visible: bool = false

var current_ui_container: Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(inventory_row_size):
		inventory_items.append([])

		for y in range(inventory_col_size):
			var instance = ITEM_SLOT.instantiate()
			instance.position = Vector2(x * 50, y * 50)
			instance.slot_number = Vector2i(x, y)
			add_child(instance)

			inventory_items[x].append(instance)
			empty_slots.append(instance)

			 
			

func prep_item(new_item) -> InventoryItemData:
	return InventoryItemData.new(new_item.item_res)
	

func add_item(item: InventoryItemData) -> bool:
	if slots_by_item_name.has(item.name):
		for slot in slots_by_item_name[item.name]:
			if slot.add_item(item):
				return true

	if empty_slots.is_empty():
		return false

	var slot = empty_slots.pop_front()

	if not slot.add_item(item):
		empty_slots.push_front(slot)
		return false

	if not slots_by_item_name.has(item.name):
		slots_by_item_name[item.name] = []

	slots_by_item_name[item.name].append(slot)
	return true
	
func attach_to_ui(container: Node) -> void:
	current_ui_container = container
	
	for x in range(inventory_row_size):
		for y in range(inventory_col_size):
			var slot = inventory_items[x][y]
			
			if slot.get_parent():
				slot.get_parent().remove_child(slot)
				
			container.add_child(slot)
			
			slot.position = Vector2(x * 50, y * 50)
		
	
func toggle():
	is_visible = (! is_visible)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("i"):
		#toggle()
		
