class_name Player
extends CharacterBody2D

var facing_direction: Vector2 = Vector2.DOWN

@onready var movement: Node = $Movement
@onready var interaction: Node = $Interaction


func _physics_process(delta: float) -> void:
	if Game.can_player_move():
		movement.physics_update(delta)
	else:
		velocity = Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"):
		return

	if Game.state == Game.State.GAME_OVER:
		restart_after_death()
		return

	if Game.state == Game.State.EXPLORATION:
		interaction.try_interact()
		

func face_direction(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		return

	movement.set_facing_direction(direction)


func die() -> void:
	if Game.state == Game.State.GAME_OVER:
		return

	velocity = Vector2.ZERO

	Game.set_state(Game.State.GAME_OVER)

	DialogueController.say(
		"",
		"Pressione Z para tentar de novo"
	)


func restart_after_death() -> void:
	Game.set_state(Game.State.EXPLORATION)

	var current_scene := get_tree().current_scene

	if current_scene == null:
		return

	get_tree().reload_current_scene()
