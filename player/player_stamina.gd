class_name PlayerStamina
extends Node

signal stamina_changed(current: float, maximum: float)

@export var max_stamina: float = 100.0
@export var drain_per_second: float = 30.0
@export var regen_per_second: float = 22.0
@export var regen_delay: float = 0.8

var current_stamina: float
var regen_timer: float = 0.0


func _ready() -> void:
	current_stamina = max_stamina
	stamina_changed.emit(current_stamina, max_stamina)


func can_run() -> bool:
	return current_stamina > 0.0


func update_stamina(delta: float, running: bool) -> void:
	var previous_stamina := current_stamina

	if running:
		regen_timer = regen_delay

		current_stamina = max(
			current_stamina - drain_per_second * delta,
			0.0
		)

	else:
		if regen_timer > 0.0:
			regen_timer -= delta
		else:
			current_stamina = min(
				current_stamina + regen_per_second * delta,
				max_stamina
			)

	if not is_equal_approx(previous_stamina, current_stamina):
		stamina_changed.emit(current_stamina, max_stamina)
