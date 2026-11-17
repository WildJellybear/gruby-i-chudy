extends CharacterBody2D
class_name Enemy
@export var speed: float = 80
var player_chase: bool = false
var player: Node2D = null
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.play("idle")

func _physics_process(delta: float) -> void:
	if player_chase:
		## position = position.move_toward(player.position, SPEED * delta)
		#position += (player.position - self.position) * speed
		velocity = (player.position - self.position) * speed * delta
	else:
		velocity = Vector2(0, 0)
	
	if velocity != Vector2.ZERO:
		animated_sprite_2d.play("side_movement")
	else:
		animated_sprite_2d.play("idle")
	
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	move_and_slide()


func _on_chase_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	Events.start_player_chase.emit(self)


func _on_chase_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	Events.stop_player_chase.emit(self)
