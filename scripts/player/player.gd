
class_name Player
extends CharacterBody2D

## ============================================================
## PLAYER - BAZOWA KLASA GRYWALNYCH POSTACI
## ============================================================


# ------------------------------------------------------------
# KONFIGURACJA
# ------------------------------------------------------------
@export var speed: float = 100.0


# ------------------------------------------------------------
# STAN POSTACI
# ------------------------------------------------------------

## Czy ta postać jest aktualnie sterowana przez gracza?
var is_player_controlled: bool = false

## Ostatni kierunek patrzenia postaci.
var facing_direction: Vector2 = Vector2.DOWN


# ------------------------------------------------------------
# REFERENCJE
# ------------------------------------------------------------
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# ------------------------------------------------------------
# INICJALIZACJA
# ------------------------------------------------------------
func _ready() -> void:
	add_to_group("playable_characters")
	update_animation()


# ------------------------------------------------------------
# STEROWANIE
# ------------------------------------------------------------

func _physics_process(_delta: float) -> void:

	if is_player_controlled:
		player_movement()
	else:
		# Zatrzymujemy nieaktywną postać.
		velocity = Vector2.ZERO
		update_animation()


## Odczytuje klawisze i wykonuje ruch postaci.
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

	# Obliczamy prędkość na podstawie kierunku.
	velocity = direction * speed

	# Zapamiętujemy kierunek tylko podczas ruchu
	if direction != Vector2.ZERO:
		facing_direction = direction

	update_animation()

	move_and_slide()


## Włącza albo wyłącza sterowanie daną postacią.
##
## Wywoływana przez CharacterManager.
## Przy wyłączeniu sterowania zatrzymujemy postać (na razie),
## ale nie zmieniamy jej pozycji ani kierunku.
func set_player_controlled(enabled: bool) -> void:
	is_player_controlled = enabled

	if not enabled:
		velocity = Vector2.ZERO
		update_animation()


# ------------------------------------------------------------
# ANIMACJE
# ------------------------------------------------------------
func update_animation() -> void:

	var is_moving: bool = velocity != Vector2.ZERO

	# Oryginalna animacja boczna patrzy w lewo.
	# Prawo uzyskujemy przez lustrzane odbicie.
	animated_sprite_2d.flip_h = (
		facing_direction == Vector2.RIGHT
	)

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


## Bezpiecznie odtwarza animację o podanej nazwie.
func play_animation(animation_name: StringName) -> void:

	var frames: SpriteFrames = animated_sprite_2d.sprite_frames

	if frames == null:
		return

	if frames.has_animation(animation_name):
		if frames.get_frame_count(animation_name) > 0:
			animated_sprite_2d.play(animation_name)
			return

	# Tymczasowa animacja zastępcza.
	if frames.has_animation("idle"):
		if frames.get_frame_count("idle") > 0:
			animated_sprite_2d.play("idle")
