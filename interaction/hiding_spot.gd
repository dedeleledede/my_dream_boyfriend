class_name HidingSpot
extends Interactable

@export var hiding_position: Marker2D
@export var pickup_text: String = "Você pegou um item."

func interact(player: Node) -> void:
	
	Game.set_state(Game.State.HIDING)
<<<<<<< HEAD
=======

	if not pickup_text.is_empty():
		DialogueController.say("", pickup_text)
>>>>>>> 8d1fd82f921f76995c4bd560e5d4dd912dfa6700
	
	player.global_position = hiding_position.global_position
	player.hide()
	set_prompt_visible(false)
