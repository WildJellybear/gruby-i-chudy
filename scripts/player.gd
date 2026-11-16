
class_name Player
extends CharacterBody2D

# Prędkość postaci ustawiana osobno w Inspektorze
@export var speed: float = 100.0

# Ostatni kierunek patrzenia (przydatny do idle i ataków)
var facing_direction: Vector2 = Vector2.DOWN

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Inicjalizacja postaci
func _ready() -> void:
	add_to_group("playable_characters")
	update_animation()


func _physics_process(_delta: float) -> void:
	player_movement()


# Obsługa ruchu i zapamiętywanie kierunku
func player_movement() -> void:
	var direction: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_down"):
		direction = Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		direction = Vector2.UP

	velocity = direction * speed

	if direction != Vector2.ZERO:
		facing_direction = direction

	update_animation()
	move_and_slide()


# Dobiera animację ruchu lub stania według kierunku
func update_animation() -> void:
	var is_moving: bool = velocity != Vector2.ZERO

	# Odbicie bocznego sprite'a (oryginał patrzy w lewo)
	animated_sprite_2d.flip_h = facing_direction == Vector2.RIGHT

	if is_moving:
		if facing_direction == Vector2.DOWN:
			play_animation("walk_down")
		elif facing_direction == Vector2.UP:
			play_animation("walk_up")
		else:
			play_animation("walk_side")
	else:
		if facing_direction == Vector2.DOWN:
			play_animation("idle_down")
		elif facing_direction == Vector2.UP:
			play_animation("idle_up")
		else:
			play_animation("idle_side")


# Odtwarza animację lub zastępcze idle, jeśli jej brakuje
func play_animation(animation_name: StringName) -> void:
	var frames: SpriteFrames = animated_sprite_2d.sprite_frames

	if frames == null:
		return

	if frames.has_animation(animation_name):
		if frames.get_frame_count(animation_name) > 0:
			animated_sprite_2d.play(animation_name)
			return

	if frames.has_animation("idle"):
		if frames.get_frame_count("idle") > 0:
			animated_sprite_2d.play("idle")
