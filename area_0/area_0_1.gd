extends Node2D
@onready var cutscene_player: AnimationPlayer = $CutscenePlayer
@onready var boyfriend: CharacterBody2D = $Boyfriend

signal dialogue_requested()

func emit_event() -> void:
	dialogue_requested.emit()

var boyfriend_dialogues := {
	1: ["boyfriend_home1a", "boyfriend_home1b", "boyfriend_home1c"]
	#2: ["boyfriend_home2a","boyfriend_home2b", "boyfriend_home2c" ],
	#3: ["boyfriend_home3a", "boyfriend_home3b", "boyfriend_home3b"],
}

var boyfriend_talk_index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.interacted.connect(_on_interacted)
	await update_cutscenes()
	pass # Replace with function body.

func update_cutscenes():
	if not Game.flags.get("home_event1_1"):
		Game.set_state(Game.State.CUTSCENE)
		await cutscene_home_event1_1()
		
	if not Game.flags.get("home_event1_2") and Game.flags.get("home_event1_1"):
		Game.set_state(Game.State.CUTSCENE)
		await cutscene_home_event1_2()
		
			

	
func cutscene_home_event1_1():
	cutscene_player.play("cutscene_home_event1a")
	
	await dialogue_requested
	cutscene_player.pause()
	Dialogic.start("home_event1a")
	await Dialogic.timeline_ended
	
	cutscene_player.play("cutscene_home_event1a")
	await dialogue_requested
	cutscene_player.pause()
	Dialogic.start("home_event1b")
	await Dialogic.timeline_ended
	
	
	Game.flags["home_event1_1"] = true
	Game.set_state(Game.State.EXPLORATION)
	cutscene_player.play("cutscene_home_event1b")
	await cutscene_player.animation_finished
	Game.flags["bf_dialogue_available"] = true
	boyfriend.set_interactable(true)
	
func cutscene_home_event1_2():
	cutscene_player.play("cutscene_home_event2a")
	await dialogue_requested
	cutscene_player.pause()
	await Dialogic.timeline_ended
	
	Dialogic.start("home_event1d")
	await Dialogic.timeline_ended
	
	Game.flags["home_event1_2"] = true
	Game.flags["home_event1_3"] = false
	SceneManager.travel_to(
		"res://area_0/area0_2.tscn",
		1,
		2,
		Vector2.LEFT)
	

	
func _on_interacted(id: String) -> void:
	
	
	match id:
		"boyfriend_talked":
			if not Game.flags.get("home_event1_1", false) or boyfriend.exhausted_dialogue:
				return
			var stage: int = Game.flags.get("home_stage", 1)
			var lines: Array = boyfriend_dialogues.get(stage, [])
			if lines.is_empty():
				return
			var i := mini(boyfriend_talk_index, lines.size() - 1)
			Game.set_state(Game.State.CUTSCENE)
			Dialogic.start(lines[i])
			boyfriend_talk_index += 1
			if $Boyfriend.max_interactions == boyfriend_talk_index:
				Game.flags["bf_dialogue_available"] = false
			await Dialogic.timeline_ended
			Game.set_state(Game.State.EXPLORATION)
		"balcony_try":
			Game.set_state(Game.State.CUTSCENE)
			Dialogic.start("interactwith_balcony")
			await Dialogic.timeline_ended
			Game.set_state(Game.State.EXPLORATION)
			
