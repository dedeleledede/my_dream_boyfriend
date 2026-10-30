extends Node


var previous_door_id: int = -1
var target_door_id: int = -1

var is_transitioning: bool = false
var unlocked_doors: Dictionary = {}

var previous_facing_direction: Vector2 = Vector2.DOWN

func travel_to(
	scene_path: String,
	from_door_id: int,
	to_door_id: int,
	facing_direction: Vector2
) -> void:
	if is_transitioning:
		return

	if scene_path.is_empty():
		push_warning("SceneManager: cena destino vazia")
		return

	is_transitioning = true

	previous_door_id = from_door_id
	target_door_id = to_door_id
	previous_facing_direction = facing_direction

	print(
		"TRAVEL: ",
		from_door_id,
		" -> ",
		to_door_id,
		" | ",
		scene_path
	)

	call_deferred("_change_scene_deferred", scene_path)


func _change_scene_deferred(scene_path: String) -> void:
	var error := get_tree().change_scene_to_file(scene_path)

	if error != OK:
		push_error("SceneManager: erro ao carregar cena %s" % scene_path)

		is_transitioning = false


func should_spawn_at(door_id: int) -> bool:
	return target_door_id == door_id


func consume_arrival(door_id: int) -> bool:
	if target_door_id != door_id:
		return false

	target_door_id = -1

	return true


func finish_transition() -> void:
	is_transitioning = false


func unlock_door(door_id: String) -> void:
	if door_id.is_empty():
		return

	unlocked_doors[door_id] = true


func is_door_unlocked(door_id: String) -> bool:
	if door_id.is_empty():
		return false

	return unlocked_doors.has(door_id)
