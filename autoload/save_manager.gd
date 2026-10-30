extends Node


signal game_saved
signal game_loaded


const SAVE_PATH := "user://save.json"


var data: Dictionary = {}


func _ready() -> void:
	reset_data()


func reset_data() -> void:
	data = {
		"current_scene": "",
		"player_position": {
			"x": 0.0,
			"y": 0.0
		},
		"inventory": {},
		"unlocked_doors": {},
		"collected_pickups": {},
		"flags": {}
	}


func unlock_door(door_id: String) -> void:
	if door_id.is_empty():
		return

	data["unlocked_doors"][door_id] = true


func is_door_unlocked(door_id: String) -> bool:
	if door_id.is_empty():
		return false

	return data["unlocked_doors"].get(door_id, false)


func collect_pickup(pickup_id: String) -> void:
	if pickup_id.is_empty():
		return

	data["collected_pickups"][pickup_id] = true


func is_pickup_collected(pickup_id: String) -> bool:
	if pickup_id.is_empty():
		return false

	return data["collected_pickups"].get(pickup_id, false)


func set_flag(flag_id: String, value = true) -> void:
	if flag_id.is_empty():
		return

	data["flags"][flag_id] = value


func get_flag(flag_id: String, default_value = false):
	return data["flags"].get(flag_id, default_value)


func store_inventory(items: Dictionary) -> void:
	data["inventory"] = items.duplicate(true)


func get_inventory() -> Dictionary:
	return data["inventory"].duplicate(true)


func store_player_state(
	scene_path: String,
	position: Vector2
) -> void:
	data["current_scene"] = scene_path

	data["player_position"] = {
		"x": position.x,
		"y": position.y
	}


func get_player_position() -> Vector2:
	var position_data: Dictionary = data["player_position"]

	return Vector2(
		float(position_data.get("x", 0.0)),
		float(position_data.get("y", 0.0))
	)


func save_game() -> bool:
	data["inventory"] = Inventory.items.duplicate(true)

	var file := FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)

	if file == null:
		push_error("SaveManager: não foi possível criar o save.")
		return false

	file.store_string(
		JSON.stringify(data, "\t")
	)

	file.close()

	game_saved.emit()

	return true


func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false

	var file := FileAccess.open(
		SAVE_PATH,
		FileAccess.READ
	)

	if file == null:
		return false

	var json_text := file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(json_text)

	if parsed == null or not parsed is Dictionary:
		push_error("SaveManager: arquivo de save inválido.")
		return false

	data = parsed

	_restore_missing_defaults()

	Inventory.items = get_inventory()
	Inventory.inventory_changed.emit()

	game_loaded.emit()

	return true


func _restore_missing_defaults() -> void:
	if not data.has("current_scene"):
		data["current_scene"] = ""

	if not data.has("player_position"):
		data["player_position"] = {
			"x": 0.0,
			"y": 0.0
		}

	if not data.has("inventory"):
		data["inventory"] = {}

	if not data.has("unlocked_doors"):
		data["unlocked_doors"] = {}

	if not data.has("collected_pickups"):
		data["collected_pickups"] = {}

	if not data.has("flags"):
		data["flags"] = {}


func new_game() -> void:
	reset_data()

	Inventory.clear()

	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path(SAVE_PATH)
		)
