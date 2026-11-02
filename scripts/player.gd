
class_name Player
extends CharacterBody2D

# Każda postać może mieć inną prędkość
@export var speed: float = 100.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	play_animation("idle")


func _physics_process(_delta: float) -> void:
	player_movement()


func player_movement() -> void:
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
		velocity.y = 0

	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		velocity.y = 0

	elif Input.is_action_pressed("ui_down"):
		velocity.x = 0
		velocity.y = speed

	elif Input.is_action_pressed("ui_up"):
		velocity.x = 0
		velocity.y = -speed

	else:
		velocity = Vector2.ZERO

	# Wspólna obsługa animacji
	if velocity.x > 0:
		animated_sprite_2d.flip_h = true
		play_animation("walk_side")

	elif velocity.x < 0:
		animated_sprite_2d.flip_h = false
		play_animation("walk_side")

	elif velocity.y > 0:
		animated_sprite_2d.flip_h = false
		play_animation("walk_down")

	elif velocity.y < 0:
		animated_sprite_2d.flip_h = false
		play_animation("walk_up")

	else:
		animated_sprite_2d.flip_h = false
		play_animation("idle")

	move_and_slide()


# Odtwarza animację tylko wtedy,
# kiedy jest dostępna dla danej postaci.
func play_animation(animation_name: StringName) -> void:
	if animated_sprite_2d.sprite_frames == null:
		return

	if animated_sprite_2d.sprite_frames.has_animation(animation_name):
		animated_sprite_2d.play(animation_name)
