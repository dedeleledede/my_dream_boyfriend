class_name HidingSpot
extends Interactable

@export var hiding_position: Marker2D

func interact(player: Node) -> void:
	Game.set_state(Game.State.HIDING)

	player.global_position = hiding_position.global_position
	player.hide()
