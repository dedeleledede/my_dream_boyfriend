extends Node

@onready var player: CharacterBody2D = get_parent()
@onready var interaction_area: Area2D = $"../InteractionArea"


func try_interact() -> void:
	if Game.state != Game.State.EXPLORATION:
		return

	var interactable := _get_nearest_interactable()

	if interactable == null:
		return

	if not interactable.can_interact(player):
		return

	interactable.interact(player)


func _get_nearest_interactable() -> Interactable:
	var nearest: Interactable = null
	var nearest_distance := INF

	for area in interaction_area.get_overlapping_areas():

		if not area is Interactable:
			continue

		var interactable := area as Interactable

		var distance := player.global_position.distance_squared_to(
			interactable.global_position
		)

		if distance < nearest_distance:
			nearest_distance = distance
			nearest = interactable

	return nearest
