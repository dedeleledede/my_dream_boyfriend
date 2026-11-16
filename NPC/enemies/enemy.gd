extends CharacterBody2D


@export var speed: float = 320.0
@export var acceleration: float = 2200.0

@export var player: Player


@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var catch_area: Area2D = $CatchArea


var last_known_position: Vector2
var has_last_known_position: bool = false


func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

	max_slides = 8
	safe_margin = 0.5

	if player == null:
		player = get_tree().current_scene.get_node_or_null("Player") as Player

	if player == null:
		push_warning("Enemy: Player não encontrado.")
		return

	nav_agent.path_desired_distance = 30.0
	nav_agent.target_desired_distance = 40.0
	nav_agent.path_max_distance = 100.0

	nav_agent.simplify_path = false

	last_known_position = _get_player_body_position()
	has_last_known_position = true

	await get_tree().physics_frame
	await get_tree().physics_frame

	nav_agent.target_position = last_known_position


func _physics_process(delta: float) -> void:
	if player == null:
		_stop(delta)
		return

	# Estados em que tudo deve parar.
	if (
		Game.state == Game.State.DIALOGUE
		or Game.state == Game.State.MENU
		or Game.state == Game.State.CUTSCENE
		or Game.state == Game.State.TRANSITION
		or Game.state == Game.State.GAME_OVER
	):
		_stop(delta)
		return

	# Enquanto vê o jogador, atualiza a última posição conhecida.
	if Game.state == Game.State.EXPLORATION:
		last_known_position = _get_player_body_position()
		has_last_known_position = true

	# Se o jogador se escondeu, NÃO atualizamos a posição.
	# O inimigo continua indo até onde o viu por último.
	if has_last_known_position:
		_follow_path(delta)
	else:
		_stop(delta)

	_check_player_capture()


func _follow_path(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		_stop(delta)
		return

	var next_position := nav_agent.get_next_path_position()

	var direction := global_position.direction_to(
		next_position
	)

	var desired_velocity := direction * speed

	velocity = velocity.move_toward(
		desired_velocity,
		acceleration * delta
	)

	move_and_slide()


func _stop(delta: float) -> void:
	velocity = velocity.move_toward(
		Vector2.ZERO,
		acceleration * delta
	)


func _get_player_body_position() -> Vector2:
	var player_collision := player.get_node_or_null(
		"CollisionShape2D"
	) as CollisionShape2D

	if player_collision != null:
		return player_collision.global_position

	return player.global_position


func _check_player_capture() -> void:
	if Game.state != Game.State.EXPLORATION:
		return

	for body in catch_area.get_overlapping_bodies():
		if body is Player:
			var caught_player := body as Player
			caught_player.die()
			return


func makepath() -> void:
	if not has_last_known_position:
		return

	if (
		Game.state != Game.State.EXPLORATION
		and Game.state != Game.State.HIDING
	):
		return

	nav_agent.target_position = last_known_position


func _on_timer_timeout() -> void:
	makepath()
