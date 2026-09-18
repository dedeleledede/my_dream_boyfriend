extends Node

@export var walk_speed: float = 120.0
@export var acceleration: float = 900.0
@export var deceleration: float = 1200.0

@onready var player: CharacterBody2D = get_parent()
@onready var sprite: Sprite2D = $"../Sprite2D"

func physics_update(delta: float) -> void:
	var input_direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	var target_velocity := input_direction * walk_speed

	var change_speed := acceleration

	if input_direction == Vector2.ZERO:
		change_speed = deceleration

	player.velocity = player.velocity.move_toward(
		target_velocity,
		change_speed * delta
	)
	
	var input_horizontal: float = Input.get_axis("move_left", "move_right")
	
	if input_horizontal != 0:
		sprite.flip_h = input_horizontal < 0

	player.move_and_slide()
