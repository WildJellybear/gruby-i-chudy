extends CharacterBody2D
class_name Enemy

enum Behavior {
	CHASE,
	ESCAPE
}

## Określa, czy przeciwnik ściga gracza, czy przed nim ucieka.
@export var behavior: Behavior = Behavior.CHASE

## Prędkość poruszania się w pikselach na sekundę.
@export var speed: float = 80.0

## Czas pomiędzy aktualizacjami celu nawigacji w sekundach.
@export_range(0.05, 1.0, 0.05) var path_update_interval: float = 0.2
var needs_path_update: bool = true

## Minimalna zmiana pozycji gracza wymagająca aktualizacji celu.
@export var path_update_distance: float = 4.0

var player_chase: bool = false
var player: Player = null
var path_update_timer: float = 0.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	animated_sprite_2d.play("idle")


func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO

	if is_instance_valid(player):
		match behavior:
			Behavior.CHASE:
				chase_player(delta)
			Behavior.ESCAPE:
				escape_from_player()

	update_animation()
	move_and_slide()


# Podąża za graczem, omijając przeszkody
# za pomocą systemu nawigacji Godota
func chase_player(delta: float) -> void:
	if NavigationServer2D.map_get_iteration_id(
		navigation_agent.get_navigation_map()
	) == 0:
		return

	path_update_timer -= delta

	if needs_path_update or path_update_timer <= 0.0:
		var target_distance: float = (
			navigation_agent.target_position.distance_to(
				player.global_position
			)
		)

		if needs_path_update or target_distance >= path_update_distance:
			navigation_agent.target_position = player.global_position
			needs_path_update = false

		path_update_timer = path_update_interval

	if navigation_agent.is_navigation_finished():
		return

	var next_position: Vector2 = (
		navigation_agent.get_next_path_position()
	)

	velocity = global_position.direction_to(next_position) * speed


# Ucieka w kierunku przeciwnym do gracza
func escape_from_player() -> void:
	var direction: Vector2 = player.global_position.direction_to(
		global_position
	)

	velocity = direction * speed


# Aktualizuje animację oraz kierunek patrzenia
func update_animation() -> void:
	var frames: SpriteFrames = animated_sprite_2d.sprite_frames
	var animation_name: StringName = "idle"

	if velocity != Vector2.ZERO:
		if frames.has_animation("side_movement") and \
			frames.get_frame_count("side_movement") > 0:
			animation_name = "side_movement"

	animated_sprite_2d.play(animation_name)

	if velocity.x != 0:
		animated_sprite_2d.flip_h = velocity.x < 0


# Wykrywa wejście gracza w obszar przeciwnika
func _on_chase_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

	if is_instance_valid(player):
		return

	player = body as Player
	path_update_timer = 0.0
	needs_path_update = true

	if behavior == Behavior.CHASE:
		player_chase = true
		Events.start_player_chase.emit(self)


# Wykrywa opuszczenie obszaru przeciwnika
func _on_chase_area_body_exited(body: Node2D) -> void:
	if body != player:
		return

	player = null

	if player_chase:
		player_chase = false
		Events.stop_player_chase.emit(self)
