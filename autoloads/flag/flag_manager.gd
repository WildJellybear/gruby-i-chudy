extends Node

## A list of flags used by the game
## Every flag MUST be added to the defined_flags list 
## and will otherwise be rejected by the Flag manager's functions.
@export var defined_flags: Array[Flag] = []
## ID-based lookup for Flags
var _id_flag: Dictionary[StringName, Flag] = {}

## Runtime state of each flag
var _flags: Dictionary[Flag,bool] = {}

func _ready() -> void:
	for f in defined_flags:
		assert(f.id != &"", "Flag ID must not be empty for flag: " + f.resource_path)
		assert(!_id_flag.has(f.id), "Duplicate flag ID: " + f.id)
		_id_flag.set(f.id,f)
		_flags.set(f,f.default_value)
		
func _set_flag(f: Flag, v: bool):
	assert(_flags.has(f), "Unknown flag: " + f.resource_path)
	Events.flag_changed.emit(f,v)
	f.flag_changed.emit(f,v)
	_flags.set(f,v)

func raise(f: Flag):
	_set_flag(f,true)

func lower(f: Flag):
	_set_flag(f,false)

func tell(f: Flag) -> bool:
	assert(_flags.has(f), "Unknown flag: " + f.resource_path)
	return _flags.get(f,f.default_value)
