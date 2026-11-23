extends CharacterBody2D

@export var id: String = ""
@export var max_interactions := 3

var interaction_count := 0

#-------

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func play_anim(anim_name: String) -> void:
	animated_sprite_2d.play(anim_name)

var player_in_range := false
var player: Player = null

var exhausted_dialogue := false

#-------------------

@onready var interactable: Area2D = $Interactable

func _ready() -> void:
	interactable.area_entered.connect(_on_area_entered)
	interactable.area_exited.connect(_on_area_exited)
	set_interactable(Game.flags.get("bf_dialogue_available", true))
	

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

func set_interactable(value: bool) -> void:
	exhausted_dialogue = not value
	if not value:
		_release_player()
	interactable.set_deferred("monitoring", value)

func _unhandled_input(event: InputEvent) -> void:
	if exhausted_dialogue:
		return
	if player_in_range \
			and _is_player_facing() \
			and event.is_action_pressed("interact") \
			and Game.state == Game.State.EXPLORATION:
		get_viewport().set_input_as_handled()
		interaction_count += 1
		Game.interacted.emit(id)
		
		if interaction_count >= max_interactions:
			exhausted_dialogue = true
			_release_player()
			interactable.set_deferred("monitoring", false)
