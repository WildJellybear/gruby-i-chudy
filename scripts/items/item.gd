extends Resource
class_name Item


@export var name : String
@export_enum("Weapon", "Herb", "Meat", "Mixture") var type: String
@export var inv_icon : Texture2D
@export var stack_amount : int = 64
@export var item_path : String
