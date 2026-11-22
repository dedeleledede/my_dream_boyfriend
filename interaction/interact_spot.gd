extends Area2D

@export var id: String = ""
@export var enabled: bool = true
@export var destroy_after_use: bool = true

var player_in_range := false
var player: Player = null

func _ready() -> void:
	if destroy_after_use and Game.is_consumed(id):
		queue_free()
		return
	if Game.is_enabled(id):
		enable()
	if not enabled:
		disable()
#--------------

func disable() -> void:
	enabled = false
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	_release_player()
	hide()

func enable() -> void:
	enabled = true
	Game.mark_enabled(id)
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)
	show()

#---------------

func _release_player() -> void:
	if player:
		player.hide_pointer()
	player = null
	player_in_range = false
	
func _physics_process(_delta: float) -> void:
	if player == null:
		return
	if _is_player_facing():
		player.show_pointer()
	else:
		player.hide_pointer()

func _is_player_facing() -> bool:
	if player == null:
		return false
	var to_me := (global_position - player.global_position).normalized()
	return player.facing_direction.dot(to_me) > 0.5

func _on_area_entered(area: Area2D) -> void:
	var p := area.get_parent() as Player
	if p == null:
		return
	player = p
	player_in_range = true
	
func _on_area_exited(area: Area2D) -> void:
	if area.get_parent() != player:
		return
	_release_player()

#-----------

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range \
			and _is_player_facing() \
			and event.is_action_pressed("interact") \
			and Game.state == Game.State.EXPLORATION:
		get_viewport().set_input_as_handled()
		Game.interacted.emit(id)
		if destroy_after_use:
			Game.mark_consumed(id)
			_release_player()
			queue_free()
			
