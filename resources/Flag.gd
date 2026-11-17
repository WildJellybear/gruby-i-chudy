extends Resource
class_name Flag

signal flag_changed(flag: Flag, value: bool)

@export var id: StringName
@export_multiline var description: String
@export var default_value: bool = false
