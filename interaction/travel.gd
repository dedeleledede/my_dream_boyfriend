extends Area2D

var entered = false
<<<<<<< HEAD
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
	
	
#player.global_position = travel_position.global_position
=======

@export_file var dest_scene

func _on_body_entered(body):
	print("entered")
	entered = true

func _on_body_exited(body):
	print("exit")
	entered = false
	
	
func _physics_process (_delta):
	if entered == true:
		if Input.is_action_just_pressed("interact"):
			get_tree().change_scene_to_file(dest_scene)
>>>>>>> 8d1fd82f921f76995c4bd560e5d4dd912dfa6700
