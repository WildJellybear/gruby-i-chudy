
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
	var direction: Vector2 = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = direction * speed

	if direction != Vector2.ZERO:
		facing_direction = direction

	update_animation()
	move_and_slide()


# Dobiera animację ruchu lub stania według kierunku
func update_animation() -> void:
	var is_moving: bool = velocity != Vector2.ZERO

	animated_sprite_2d.flip_h = facing_direction.x > 0

	var action: String = "walk" if is_moving else "idle"
	var direction_name: String = "side"

	if facing_direction.x != 0:
		direction_name = "side"
	elif facing_direction.y > 0:
		direction_name = "down"
	elif facing_direction.y < 0:
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
