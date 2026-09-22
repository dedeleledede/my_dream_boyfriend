extends Node

@onready var player: Player = get_parent()
@onready var interaction_area: Area2D = $"../InteractionArea"

var current_interactable: Interactable = null


func _physics_process(_delta: float) -> void:
	_update_current_interactable()


func try_interact() -> void:
	if Game.state != Game.State.EXPLORATION:
		return

	var interactable := _get_nearest_interactable()

	if interactable == null:
		return

	if not interactable.can_interact(player):
		return

	interactable.interact(player)


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
	var offset := interactable.global_position - player.global_position

	# Caso predominantemente vertical:
	# não exigimos direção horizontal.
	if abs(offset.y) >= abs(offset.x):
		return true

	# Objeto à direita.
	if offset.x > 0.0:
		return player.facing_horizontal > 0

	# Objeto à esquerda.
	if offset.x < 0.0:
		return player.facing_horizontal < 0

	return true
