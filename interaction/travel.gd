class_name Travel
extends Area2D


@export_file("*.tscn") var dest_scene: String = ""

@export var door_id: int = 0
@export var target_door_id: int = 0

@onready var spawn_point: Marker2D = $SpawnPoint

var arrival_locked: bool = false
var active: bool = true
var arrived_here: bool = false


func _ready() -> void:
	if not SceneManager.consume_arrival(door_id):
		return

	arrived_here = true
	arrival_locked = true
	monitoring = false

	var current_scene := get_tree().current_scene
	var player := current_scene.get_node_or_null("Player") as Player

	if player == null:
		push_warning("Travel: não encontrou Player.")
		SceneManager.finish_transition()
		arrival_locked = false
		return

	player.global_position = spawn_point.global_position

	await get_tree().physics_frame
	await get_tree().physics_frame

	set_deferred("monitoring", active)

	await get_tree().physics_frame

	SceneManager.finish_transition()

	if not active or not overlaps_body(player):
		arrival_locked = false


func set_active(value: bool) -> void:
	active = value
	set_deferred("monitoring", value)


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

	if not active:
		return

	if arrival_locked:
		return

	if SceneManager.is_transitioning:
		return

	if dest_scene.is_empty():
		push_warning("Travel: dest_scene está vazio.")
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
