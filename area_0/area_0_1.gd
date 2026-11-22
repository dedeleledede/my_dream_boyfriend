extends Node2D
@onready var cutscene_player: AnimationPlayer = $CutscenePlayer
@onready var boyfriend: CharacterBody2D = $Boyfriend

signal dialogue_requested()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await update_cutscenes()
	pass # Replace with function body.

func update_cutscenes():
	if not Game.flags.get("home_event1_1", false):
		Game.set_state(Game.State.CUTSCENE)
		await cutscene_home_event1_1()
		Game.flags["home_event1_1"] = true
		Game.set_state(Game.State.EXPLORATION)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func cutscene_home_event1_1():
	cutscene_player.play("cutscene_home_event1")
	
	await dialogue_requested
	cutscene_player.pause()
	Dialogic.start("home_event1a")
	await Dialogic.timeline_ended
	
	cutscene_player.play("cutscene_home_event1")
	await dialogue_requested
	cutscene_player.pause()
	Dialogic.start("home_event1b")
	await Dialogic.timeline_ended
	
	Game.set_state(Game.State.EXPLORATION)
	cutscene_player.play("cutscene_home_event1")
	
	return

func emit_event() -> void:
	dialogue_requested.emit()
