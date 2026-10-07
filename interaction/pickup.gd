class_name Pickup
extends Interactable

@export var item_id: String = ""
@export var amount: int = 1
@export var pickup_text: String = "Você pegou um item."
@export var destroy_on_pickup: bool = true


func interact(_player: Node) -> void:
	if item_id.is_empty():
		return

	Inventory.add_item(item_id, amount)

	if not pickup_text.is_empty():
		DialogueController.say("", pickup_text)

	set_prompt_visible(false)

	if destroy_on_pickup:
		queue_free()
