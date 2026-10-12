class_name HidingSpot
extends Interactable

@export var hiding_position: Marker2D
@export var pickup_text: String = "Você pegou um item."

func interact(player: Node) -> void:
	Game.set_state(Game.State.HIDING)

	if not pickup_text.is_empty():
		DialogueController.say("", pickup_text)
	
	player.global_position = hiding_position.global_position
	player.hide()
