extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Inventory.attach_to_ui(self)
	Inventory.attach_to_ui.call_deferred(self)
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
