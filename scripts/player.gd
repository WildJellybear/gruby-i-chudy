extends CharacterBody2D

# const INVENTORY = preload("res://globals/inventory.gd")

const SPEED = 100.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.play("idle")
	name = "player"

func _physics_process(delta: float) -> void:
	player_movement(delta)
	
func player_movement(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		velocity.x = 0
		velocity.y = SPEED
	elif Input.is_action_pressed("ui_up"):
		velocity.x = 0
		velocity.y = -SPEED
	else:
		velocity.x = 0
		velocity.y = 0
		
		
	
	move_and_slide()
