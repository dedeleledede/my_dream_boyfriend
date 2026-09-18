extends Node

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
