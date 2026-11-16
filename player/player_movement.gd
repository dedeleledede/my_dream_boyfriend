extends Node

@export var walk_speed: float = 400.0
@export var run_speed: float = 650.0

@export var acceleration: float = 6000.0
@export var deceleration: float = 5000.0

@onready var player: Player = get_parent()
@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
#@onready var sprite: Sprite2D = $"../Sprite2D"
@onready var stamina: PlayerStamina = $"../Stamina"
var last_dir = "down"

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

	_update_facing_direction(input_direction)

	stamina.update_stamina(delta, is_running)

	player.move_and_slide()

func set_facing_direction(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		return

	_update_facing_direction(direction)

func _update_facing_direction(_direction: Vector2) -> void:
	
	if player.velocity.length() > 5:
		if abs(player.velocity.x) > abs(player.velocity.y):
			if player.velocity.x > 0.0:
				player.facing_direction = Vector2.RIGHT
				#sprite.texture = sprite_side
				sprite.play("walk_right")
				last_dir = "right"
				#sprite.flip_h = false

			else:
				player.facing_direction = Vector2.LEFT
				#sprite.texture = sprite_side
				sprite.play("walk_left")
				last_dir = "left"
				#sprite.flip_h = true

		else:
			#sprite.flip_h = false

			if player.velocity.y > 0.0:
				player.facing_direction = Vector2.DOWN
				sprite.play("walk_down")
				last_dir = "down"

			else:
				player.facing_direction = Vector2.UP
				sprite.play("walk_up")
				last_dir = "up"
	else:
		sprite.play("idle_"+last_dir)
		
