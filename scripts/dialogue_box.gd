extends CanvasLayer

@onready var name_label: Label = $PanelContainer/MarginContainer/VBoxContainer/NameLabel
@onready var text_label: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/TextLabel

var dialogue_lines: Array[String] = []
var current_line_index: int = 0
var is_active: bool = false

func _ready() -> void:
	hide()

func start_dialogue(speaker_name: String, lines: Array[String]) -> void:
	if lines.is_empty():
		return
	
	name_label.text = speaker_name
	dialogue_lines = lines
	current_line_index = 0
	is_active = true
	
	show()
	_show_line()

func _show_line() -> void:
	text_label.text = dialogue_lines[current_line_index]
	# Optional typewriter effect
	text_label.visible_ratio = 0.0
	var tween = create_tween()
	tween.tween_property(text_label, "visible_ratio", 1.0, 0.5)

func _unhandled_input(event: InputEvent) -> void:
	if not is_active:
		return
		
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		current_line_index += 1
		
		if current_line_index < dialogue_lines.size():
			_show_line()
		else:
			end_dialogue()

func end_dialogue() -> void:
	is_active = false
	hide()
