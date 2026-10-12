class_name Inspectable
extends Interactable

@export var speaker_name: String = "test"
@export_multiline var text: String = "test"


func interact(_player: Node) -> void:
	DialogueController.say(
		speaker_name,
		text
	)
