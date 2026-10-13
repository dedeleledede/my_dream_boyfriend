extends Area2D

var entered = false
@export var player: Node2D


@export_file var dest_scene
@export var door_id: int
@export var target_door_id: int


func _on_body_entered(_body):
	entered = true
	

func _on_body_exited(_body):
	entered = false
	
func _physics_process(_delta):
	if entered == true:
		SceneManager.previous_door_id = door_id
		get_tree().change_scene_to_file(dest_scene)
	
	
