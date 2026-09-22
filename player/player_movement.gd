extends Node

@export var walk_speed: float = 120.0
@export var run_speed: float = 190.0

@export var acceleration: float = 900.0
@export var deceleration: float = 1200.0

@export_group("Sprites")
@export var sprite_front: Texture2D
@export var sprite_back: Texture2D
@export var sprite_side: Texture2D

@onready var player: Player = get_parent()
@onready var sprite: Sprite2D = $"../Sprite2D"
@onready var stamina: PlayerStamina = $"../Stamina"


func physics_update(delta: float) -> void:
	var input_direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	var wants_to_run := (
		Input.is_action_pressed("run")
		and input_direction != Vector2.ZERO
	)

	var is_running := (
		wants_to_run
		and stamina.can_run()
	)

	var current_speed := walk_speed

	if is_running:
		current_speed = run_speed

	var target_velocity := input_direction * current_speed

	var change_speed := acceleration

	if input_direction == Vector2.ZERO:
		change_speed = deceleration

	player.velocity = player.velocity.move_toward(
		target_velocity,
		change_speed * delta
	)

	if input_direction != Vector2.ZERO:
		_update_facing_direction(input_direction)

	stamina.update_stamina(delta, is_running)

	player.move_and_slide()


func _update_facing_direction(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):

		if direction.x > 0.0:
			player.facing_direction = Vector2.RIGHT
			sprite.texture = sprite_side
			sprite.flip_h = false

		else:
			player.facing_direction = Vector2.LEFT
			sprite.texture = sprite_side
			sprite.flip_h = true

	else:
		sprite.flip_h = false

		if direction.y > 0.0:
			player.facing_direction = Vector2.DOWN
			sprite.texture = sprite_front

		else:
			player.facing_direction = Vector2.UP
			sprite.texture = sprite_back
