class_name Pickup
extends Interactable


@export var pickup_state_id: String = ""

@export var item_id: String = ""
@export var amount: int = 1

@export var pickup_text: String = "Você pegou um item."
@export var destroy_on_pickup: bool = true


func _ready() -> void:
	super._ready()

	if pickup_state_id.is_empty():
		return

	if SaveManager.is_pickup_collected(pickup_state_id):
		queue_free()


func interact(_player: Node) -> void:
	if item_id.is_empty():
		return

	if not pickup_state_id.is_empty():
		SaveManager.collect_pickup(pickup_state_id)
		SaveManager.save_game()

	Inventory.add_item(item_id, amount)

	if not pickup_text.is_empty():
		DialogueController.say("", pickup_text)

	set_prompt_visible(false)

	if destroy_on_pickup:
		queue_free()
