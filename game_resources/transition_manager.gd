class_name Transition extends CanvasLayer

signal transition_in_complete
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var starting_animation_name:String
	
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func start_transition() -> void:
	get_tree().paused = true
	animation_player.play("fade_to_black")
	
	
# called by SceneManger to play the outro to the transition once the content is loaded
func finish_transition() -> void:
	# construct second half of the transitation's animation name
	get_tree().paused = false
	animation_player.play("fade_from_black")
	
	# once this final animation plays, we can free this scene
	await animation_player.animation_finished
	queue_free()

func report_midpoint() -> void:
	transition_in_complete.emit()
