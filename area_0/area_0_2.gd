extends Node2D
@onready var cutscene_player: AnimationPlayer = $CutscenePlayer

signal dialogue_requested()

func emit_event() -> void:
	dialogue_requested.emit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await update_cutscenes()
	Game.interacted.connect(_on_interacted)
	
	pass # Replace with function body.

func update_cutscenes():
	if not Game.flags.get("home_event1_3"):
			Game.set_state(Game.State.CUTSCENE)
			await cutscene_home_event1_3()
			Game.flags["home_event1_3"] = true
			Game.set_state(Game.State.EXPLORATION)
			
func cutscene_home_event1_3():
	
	cutscene_player.play("cutscene_home_event3a")
	await dialogue_requested
	cutscene_player.pause()
	
	Dialogic.start("home_event1e")
	await Dialogic.timeline_ended
	
	cutscene_player.play("cutscene_home_event3a")
	await dialogue_requested
	cutscene_player.pause()
	
	Dialogic.start("home_event1f")
	await Dialogic.timeline_ended
	
	#$BedWB.visible = true
	#$Player.hide()
	get_tree().quit()

func _on_interacted(id: String) -> void:
	match id:
		"intro_bath":
			Game.set_state(Game.State.CUTSCENE)
			
			TransitionManager.fade_out()
			
			await TransitionManager.transition_in_complete
			
			Dialogic.start("home_event1c")
			await get_tree().create_timer(1.2).timeout
			Game.flags["bf_dialogue_available"] = false
			Game.flags["home_event1_2"] = false
			get_tree().change_scene_to_file("res://area_0/area0_1.tscn")
		#"blah":
			#print("blah")
			#$InteractSpot2.enable()
