class_name Player
extends CharacterBody2D

var facing_direction: Vector2 = Vector2.DOWN

@onready var movement: Node = $Movement
@onready var interaction: Node = $Interaction


func _physics_process(delta: float) -> void:
	if Game.can_player_move():
		movement.physics_update(delta)
	else:
		velocity = Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interaction.try_interact()
