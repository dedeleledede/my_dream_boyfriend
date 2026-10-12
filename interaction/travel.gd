extends Area2D

var entered = false

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
