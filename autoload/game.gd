extends Node

@onready var pause_menu_scene: PackedScene = preload("res://game_ui/ui_menus/pause_menu.tscn")
var pause_menu: Node = null

var flags := {
	"home_event1_1": false,
	"home_event1_2": false,
	"home_event2": false,
	"home_event3": false,
	"ending_event_dream": false,
	"ending_event_nightmare": false,
	"ending_event_lucid":false}

#flags:
	#world:
	#endings: dream, nightmare, lucid


		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if pause_menu == null:
			open_pause()
		else:
			close_pause()

func open_pause() -> void:
	pause_menu = pause_menu_scene.instantiate()
	add_child(pause_menu)
	get_tree().paused = true

func close_pause() -> void:
	pause_menu.queue_free()
	pause_menu = null
	get_tree().paused = false

signal state_changed(old_state: State, new_state: State)
signal world_changed(world: World)

enum State {
	EXPLORATION,
	DIALOGUE,
	MENU,
	HIDING,
	CUTSCENE,
	TRANSITION,
	GAME_OVER
}

enum World {
	AWAKE,
	DREAM
}

var state: State = State.EXPLORATION
var world: World = World.AWAKE

func set_state(new_state: State) -> void:
	if new_state == state:
		return

	var old_state := state
	state = new_state

	state_changed.emit(old_state, new_state)


func set_world(new_world: World) -> void:
	if world == new_world:
		return

	world = new_world
	world_changed.emit(world)


func can_player_move() -> bool:
	return state == State.EXPLORATION


func can_open_inventory() -> bool:
	return (
		state == State.EXPLORATION
		and world == World.DREAM
	)
