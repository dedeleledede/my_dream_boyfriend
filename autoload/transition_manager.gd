class_name Transition extends CanvasLayer

signal transition_in_complete
@onready var animation_player: AnimationPlayer = $AnimationPlayer
	
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	animation_player.play("RESET")
#--- this is from a tutorial i found

func start_transition_scene() -> void:
	
	animation_player.play("fade_to_black")
	
	
# called by SceneManger to play the outro to the transition once the content is loaded
func finish_transition_scene() -> void:
	# construct second half of the transitation's animation name
	get_tree().paused = false
	animation_player.play("fade_from_black")
	
	# once this final animation plays, we can free this scene
	await animation_player.animation_finished
	
	
#---------------

#just animations, no pause
func fade_out() -> void:
	animation_player.play("fade_to_black_slow")

func fade_in() -> void:
	animation_player.play("fade_from_black_slow")
	await animation_player.animation_finished
	
func report_midpoint() -> void:
	transition_in_complete.emit()
