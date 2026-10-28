extends Area2D


@export_file("*.tscn") var dest_scene: String = ""

@export var door_id: int = 0
@export var target_door_id: int = 0

@onready var spawn_point: Marker2D = $Marker2D


var arrival_locked: bool = false


func _ready() -> void:
	if not SceneManager.consume_arrival(door_id):
		return

	arrival_locked = true

	var player := get_parent().get_node_or_null("Player") as Player

	if player == null:
		push_warning("Travel: nao encontrou Player")
		SceneManager.finish_transition()
		return

	monitoring = false

	player.global_position = spawn_point.global_position

	print(
		"SPAWN: door ",
		door_id,
		" em ",
		spawn_point.global_position
	)

	await get_tree().physics_frame
	await get_tree().physics_frame

	monitoring = true

	await get_tree().physics_frame

	SceneManager.finish_transition()

	if not overlaps_body(player):
		arrival_locked = false


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

	if arrival_locked:
		return

	if SceneManager.is_transitioning:
		return

	if dest_scene.is_empty():
		push_warning("Travel: dest_scene esta vazio")
		return

	set_deferred("monitoring", false)

	SceneManager.travel_to(
		dest_scene,
		door_id,
		target_door_id
	)


func _on_body_exited(body: Node2D) -> void:
	if not body is Player:
		return

	arrival_locked = false
