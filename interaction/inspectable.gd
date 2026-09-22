class_name Inspectable
extends Interactable

@export var speaker_name: String = ""
@export_multiline var text: String = ""


func interact(_player: Node) -> void:
	DialogueController.say(
		speaker_name,
		text
	)
