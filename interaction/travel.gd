class_name Travel
extends Area2D


@export_file("*.tscn") var dest_scene: String = ""

@export var door_id: int = 0
@export var target_door_id: int = 0
@export_enum("Up", "Down", "Left", "Right")
var enter_direction: int = 0

@export_range(0.0, 1.0) var direction_threshold: float = 0.65

@onready var spawn_point: Marker2D = $SpawnPoint


var arrival_locked: bool = false
var active: bool = true
var arrived_here: bool = false

var player_inside: Player = null
var travel_started: bool = false


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

	# Mantém a direção/sprite que o Player tinha
	# antes da troca de sala.
	player.face_direction(
		SceneManager.previous_facing_direction
	)

	await get_tree().physics_frame
	await get_tree().physics_frame

	set_deferred("monitoring", active)

	await get_tree().physics_frame

	SceneManager.finish_transition()

	if not active or not overlaps_body(player):
		arrival_locked = false


func _physics_process(_delta: float) -> void:
	if player_inside == null:
		return

	if not active:
		return

	if arrival_locked:
		return

	if travel_started:
		return

	if SceneManager.is_transitioning:
		return

	if not Game.can_player_move():
		return

	_try_enter_door()


func _try_enter_door() -> void:
	var input_direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	if input_direction == Vector2.ZERO:
		return

	var required_direction := get_required_direction()

	var movement_alignment := input_direction.normalized().dot(
		required_direction
	)

	if movement_alignment < direction_threshold:
		return

	_start_travel()


func _start_travel() -> void:
	if travel_started:
		return

	if player_inside == null:
		return

	if dest_scene.is_empty():
		push_warning("Travel: dest_scene está vazio.")
		return

	travel_started = true
	active = false

	var player := player_inside

	set_deferred("monitoring", false)

	var door := get_parent() as Door

	if door != null:
		await door.play_entry_animation()

	SceneManager.travel_to(
		dest_scene,
		door_id,
		target_door_id,
		player.facing_direction
	)


func set_active(value: bool) -> void:
	active = value

	if not travel_started:
		set_deferred("monitoring", value)


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

	player_inside = body as Player


func _on_body_exited(body: Node2D) -> void:
	if not body is Player:
		return

	if player_inside == body:
		player_inside = null

	arrival_locked = false


func get_required_direction() -> Vector2:
	match enter_direction:
		0:
			return Vector2.UP

		1:
			return Vector2.DOWN

		2:
			return Vector2.LEFT

		3:
			return Vector2.RIGHT

	return Vector2.UP
