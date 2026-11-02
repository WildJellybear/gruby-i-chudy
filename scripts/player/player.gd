
class_name Player
extends CharacterBody2D

## ============================================================
## PLAYER - KLASA BAZOWA GRYWALNYCH POSTACI
## ============================================================
@export var speed: float = 100.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# ------------------------------------------------------------
# STAN POSTACI
# ------------------------------------------------------------

## Ostatni kierunek, w którym poruszała się postać.
##
## Dostępne wartości:
## Vector2.UP    = ( 0, -1)
## Vector2.DOWN  = ( 0,  1)
## Vector2.LEFT  = (-1,  0)
## Vector2.RIGHT = ( 1,  0)
var facing_direction: Vector2 = Vector2.DOWN


# ------------------------------------------------------------
# INICJALIZACJA
# ------------------------------------------------------------
func _ready() -> void:
	add_to_group("playable_characters")
	update_animation()


# ------------------------------------------------------------
# AKTUALIZACJA FIZYKI
# ------------------------------------------------------------
func _physics_process(_delta: float) -> void:
	player_movement()


# ------------------------------------------------------------
# PORUSZANIE POSTACIĄ
# ------------------------------------------------------------
func player_movement() -> void:

	# Kierunek aktualnego ruchu.
	# ZERO oznacza brak wciśniętego kierunku.
	var direction: Vector2 = Vector2.ZERO

	# Odczyt wejścia gracza.
	if Input.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT

	elif Input.is_action_pressed("ui_left"):
		direction = Vector2.LEFT

	elif Input.is_action_pressed("ui_down"):
		direction = Vector2.DOWN

	elif Input.is_action_pressed("ui_up"):
		direction = Vector2.UP

	# Wyliczenie prędkości ruchu.
	velocity = direction * speed

	# Zapamiętujemy ostatni kierunek wyłącznie,
	# gdy gracz rzeczywiście wciska kierunek ruchu.
	if direction != Vector2.ZERO:
		facing_direction = direction

	update_animation()

	move_and_slide()


# ------------------------------------------------------------
# WYBÓR ANIMACJI
# ------------------------------------------------------------
func update_animation() -> void:

	# Sprawdzamy, czy postać aktualnie się porusza.
	var is_moving: bool = velocity != Vector2.ZERO

	if facing_direction == Vector2.RIGHT:
		animated_sprite_2d.flip_h = true

	elif facing_direction == Vector2.LEFT:
		animated_sprite_2d.flip_h = false

	else:
		animated_sprite_2d.flip_h = false

	# Postać jest w ruchu.
	if is_moving:

		if facing_direction == Vector2.DOWN:
			play_animation("walk_down")

		elif facing_direction == Vector2.UP:
			play_animation("walk_up")

		else:
			play_animation("walk_side")

	# Postać stoi - wybieramy idle
	# na podstawie ostatniego kierunku.
	else:

		if facing_direction == Vector2.DOWN:
			play_animation("idle_down")

		elif facing_direction == Vector2.UP:
			play_animation("idle_up")

		else:
			play_animation("idle_side")


# ------------------------------------------------------------
# BEZPIECZNE ODTWARZANIE ANIMACJI
# ------------------------------------------------------------

## Odtwarza animację o podanej nazwie jeżeli taka istnieje i nie jest pusta
func play_animation(animation_name: StringName) -> void:

	var frames: SpriteFrames = animated_sprite_2d.sprite_frames

	if frames == null:
		return

	if frames.has_animation(animation_name):
		if frames.get_frame_count(animation_name) > 0:
			animated_sprite_2d.play(animation_name)
			return

	# Animacja zastępcza dla niegotowych kierunków.
	if frames.has_animation("idle"):
		if frames.get_frame_count("idle") > 0:
			animated_sprite_2d.play("idle")
