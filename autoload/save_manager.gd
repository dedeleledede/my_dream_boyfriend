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
