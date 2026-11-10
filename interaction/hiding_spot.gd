class_name HidingSpot
extends Interactable


@onready var hiding_point: Marker2D = $HidingPoint
@onready var exit_point: Marker2D = $ExitPoint


var hidden_player: Player = null
var is_hiding: bool = false
var can_exit: bool = false


func interact(player: Node) -> void:
	if is_hiding:
		return

	if not player is Player:
		return

	hidden_player = player as Player
	is_hiding = true
	can_exit = false

	Game.set_state(Game.State.HIDING)

	hidden_player.velocity = Vector2.ZERO
	hidden_player.global_position = hiding_point.global_position
	hidden_player.hide()

	set_prompt_visible(false)

	# Impede o mesmo Z usado para entrar
	# de também fazer o Player sair.
	await get_tree().process_frame

	can_exit = true


func _unhandled_input(event: InputEvent) -> void:
	if not is_hiding:
		return

	if not can_exit:
		return

	if not event.is_action_pressed("interact"):
		return

	can_exit = false

	get_viewport().set_input_as_handled()

	exit_hiding()


func exit_hiding() -> void:
	if hidden_player == null:
		return

	hidden_player.global_position = exit_point.global_position
	hidden_player.velocity = Vector2.ZERO
	hidden_player.show()

	is_hiding = false

	Game.set_state(Game.State.EXPLORATION)

	hidden_player = null
