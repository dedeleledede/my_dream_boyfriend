extends Area2D

@export var dialogue_timeline: String = ""
@export var flag_set: String = ""
@export var one_time := false
@export var transition: bool

var player_in_range := false
var used := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range \
			and event.is_action_pressed("interact") \
			and Game.state == Game.State.EXPLORATION \
			and not (one_time and used):
		get_viewport().set_input_as_handled()
		interact()

func interact() -> void:
	used = true
	Game.set_state(Game.State.DIALOGUE)
	if dialogue_timeline != "":
		Dialogic.start(dialogue_timeline)
		await Dialogic.timeline_ended
	if flag_set != "":
		Game.flags[flag_set] = true
	Game.set_state(Game.State.EXPLORATION)
