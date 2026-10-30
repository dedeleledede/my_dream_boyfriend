class_name Door
extends Interactable


@export_group("Door State")

@export var door_state_id: String = ""

@export var starts_locked: bool = false
@export var required_item: String = ""
@export var consume_key: bool = false


@export_group("Dialogue")

@export var locked_text: String = "Esta trancada"
@export var unlocked_text: String = "A porta foi destrancada"


@export_group("Visual")

@export var closed_texture: Texture2D
@export var opened_texture: Texture2D


@export_group("Travel")

@export_file("*.tscn") var dest_scene: String = ""

@export var door_id: int = 0
@export var target_door_id: int = 0


@onready var sprite: Sprite2D = $Sprite2D

@onready var blocker: CollisionShape2D = \
	$StaticBody2D/CollisionShape2D

@onready var travel: Travel = $Travel


var locked: bool = false
var opened: bool = false


func _enter_tree() -> void:
	var travel_node := get_node_or_null("Travel") as Travel

	if travel_node == null:
		return

	travel_node.dest_scene = dest_scene
	travel_node.door_id = door_id
	travel_node.target_door_id = target_door_id


func _ready() -> void:
	super._ready()

	locked = starts_locked

	if SceneManager.is_door_unlocked(door_state_id):
		locked = false

	# Se acabamos de chegar nesta sala por esta porta,
	# ela deve estar aberta.
	if travel.arrived_here:
		locked = false

		SceneManager.unlock_door(door_state_id)

		_set_opened(true)
	else:
		_set_opened(false)


func can_interact(_player: Node) -> bool:
	return not opened


func interact(_player: Node) -> void:
	if opened:
		return

	if locked:
		if required_item.is_empty():
			DialogueController.say("", locked_text)
			return

		if not Inventory.has_item(required_item):
			DialogueController.say("", locked_text)
			return

		if consume_key:
			Inventory.remove_item(required_item)

		locked = false

		SceneManager.unlock_door(door_state_id)

		_set_opened(true)

		if not unlocked_text.is_empty():
			DialogueController.say("", unlocked_text)

		return

	_set_opened(true)


func _set_opened(value: bool) -> void:
	opened = value

	if opened:
		if opened_texture != null:
			sprite.texture = opened_texture

		blocker.set_deferred("disabled", true)

		travel.set_active(true)

		set_prompt_visible(false)

	else:
		if closed_texture != null:
			sprite.texture = closed_texture

		blocker.set_deferred("disabled", false)

		travel.set_active(false)
