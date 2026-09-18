class_name Inspectable
extends Interactable

@export_multiline var text := ""

func interact(_player: Node) -> void:
	DialogueController.say("", text)
