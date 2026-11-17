extends Node2D

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
	print ("temp1")
