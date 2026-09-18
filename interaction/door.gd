class_name Door
extends Interactable

@export var locked := false
@export var required_item := ""
@export_file("*.tscn") var target_scene := ""

func interact(_player: Node) -> void:

	if locked:
		if Inventory.has_item(required_item):
			Inventory.remove_item(required_item)
			locked = false
		else:
			DialogueController.say("", "Está trancada.")
			return

	SceneManager.change_scene(target_scene)
