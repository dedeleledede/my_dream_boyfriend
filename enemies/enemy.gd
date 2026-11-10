extends CharacterBody2D


const speed := 420.0

@export var player: Player

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D


func _physics_process(_delta: float) -> void:
	if Game.state != Game.State.EXPLORATION:
		velocity = Vector2.ZERO
		return

	if player == null:
		velocity = Vector2.ZERO
		return

	var next_path_pos := nav_agent.get_next_path_position()
	var direction := global_position.direction_to(next_path_pos)

	velocity = direction * speed

	move_and_slide()


func makepath() -> void:
	if Game.state != Game.State.EXPLORATION:
		return

	if player == null:
		return

	nav_agent.target_position = player.global_position


func _on_timer_timeout() -> void:
	makepath()


func _on_catch_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

	if Game.state != Game.State.EXPLORATION:
		return

	var caught_player := body as Player

	caught_player.die()
