class_name Door
extends Interactable

@export var locked := false
@export var required_item := ""
@export_file("*.tscn") var target_scene := ""

@export var locked_text: String = "Está trancada."
@export var unlocked_text: String = "A porta foi destrancada."


func interact(_player: Node) -> void:
	if locked:
		if required_item.is_empty() or Inventory.has_item(required_item):
			if not required_item.is_empty():
				Inventory.remove_item(required_item)

			locked = false
			DialogueController.say("", unlocked_text)
		else:
			DialogueController.say("", locked_text)
			return

	if not target_scene.is_empty():
		SceneManager.change_scene(target_scene)
