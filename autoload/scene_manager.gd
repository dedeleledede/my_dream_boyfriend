extends Node


var previous_door_id: int = -1
var target_door_id: int = -1

var is_transitioning: bool = false


func travel_to(
	scene_path: String,
	from_door_id: int,
	to_door_id: int
) -> void:
	if is_transitioning:
		return

	if scene_path.is_empty():
		push_warning("SceneManager: cena destino vazia")
		return

	is_transitioning = true

	previous_door_id = from_door_id
	target_door_id = to_door_id

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
