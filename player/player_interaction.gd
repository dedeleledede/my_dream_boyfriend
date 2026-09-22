extends Node

@export_range(-1.0, 1.0, 0.05)
var facing_threshold: float = 0.65

@onready var player: Player = get_parent()
@onready var interaction_area: Area2D = $"../InteractionArea"

var current_interactable: Interactable = null


func _physics_process(_delta: float) -> void:
	_update_current_interactable()


func try_interact() -> void:
	if Game.state != Game.State.EXPLORATION:
		return

	if current_interactable == null:
		return

	if not current_interactable.can_interact(player):
		return

	current_interactable.interact(player)


func _update_current_interactable() -> void:
	if Game.state != Game.State.EXPLORATION:
		_set_current_interactable(null)
		return

	var interactable := _get_nearest_interactable()

	_set_current_interactable(interactable)


func _set_current_interactable(interactable: Interactable) -> void:
	if current_interactable == interactable:
		return

	if current_interactable != null:
		current_interactable.set_prompt_visible(false)

	current_interactable = interactable

	if current_interactable != null:
		current_interactable.set_prompt_visible(true)


func _get_nearest_interactable() -> Interactable:
	var nearest: Interactable = null
	var nearest_distance := INF

	for area in interaction_area.get_overlapping_areas():

		if not area is Interactable:
			continue

		var interactable := area as Interactable

		if not interactable.can_interact(player):
			continue

		if not _is_facing_interactable(interactable):
			continue

		var distance := player.global_position.distance_squared_to(
			interactable.global_position
		)

		if distance < nearest_distance:
			nearest_distance = distance
			nearest = interactable

	return nearest


func _is_facing_interactable(interactable: Interactable) -> bool:
	var to_interactable := (
		interactable.global_position
		- player.global_position
	)

	if to_interactable.length_squared() == 0.0:
		return true

	var direction_to_interactable := to_interactable.normalized()

	var facing_amount := player.facing_direction.dot(
		direction_to_interactable
	)

	return facing_amount >= facing_threshold
