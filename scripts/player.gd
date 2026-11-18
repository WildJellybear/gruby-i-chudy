
class_name Player
extends CharacterBody2D
# class_name Player

# Prędkość postaci ustawiana osobno w Inspektorze
@export var speed: float = 100.0

# Ostatni kierunek patrzenia (przydatny do idle i ataków)
var facing_direction: Vector2 = Vector2.DOWN

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Inicjalizacja postaci
func _ready() -> void:
	add_to_group("playable_characters")
	update_animation()
  # animated_sprite_2d.play("idle")
	# Game.player = self


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

	animated_sprite_2d.flip_h = facing_direction == Vector2.RIGHT

	var action: String = "walk" if is_moving else "idle"
	var direction_name: String = "side"

	if facing_direction == Vector2.DOWN:
		direction_name = "down"
	elif facing_direction == Vector2.UP:
		direction_name = "up"

	play_animation(action + "_" + direction_name)



# Odtwarza animację lub zastępcze idle, jeśli jej brakuje

func play_animation(animation_name: StringName) -> void:
	var frames: SpriteFrames = animated_sprite_2d.sprite_frames

	assert(frames != null, "Brak SpriteFrames dla postaci")
	if frames == null:
		return
	assert(
		frames.has_animation(animation_name),
		"Brak animacji: " + str(animation_name)
	)
	if not frames.has_animation(animation_name):
		return
	assert(
		frames.get_frame_count(animation_name) > 0,
		"Animacja nie ma klatek: " + str(animation_name)
	)
	if frames.get_frame_count(animation_name) > 0:
		animated_sprite_2d.play(animation_name)
