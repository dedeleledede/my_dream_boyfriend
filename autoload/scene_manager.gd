extends Node

var previous_door_id: int

#@onready var player: CharacterBody2D = $Player
#@onready var travel_spots: Node = $Travel

#func change_scene(scene_path: String) -> void:
	#if scene_path.is_empty():
		#push_warning("SceneManager: target_scene ta vazio")
		#return
#
	#get_tree().change_scene_to_file(scene_path)
