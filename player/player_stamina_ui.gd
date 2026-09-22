extends CanvasLayer

@onready var stamina_bar: ProgressBar = $StaminaBar
@onready var stamina: PlayerStamina = $"../Stamina"


func _ready() -> void:
	stamina.stamina_changed.connect(_on_stamina_changed)

	stamina_bar.max_value = stamina.max_stamina
	stamina_bar.value = stamina.current_stamina
	stamina_bar.visible = false


func _on_stamina_changed(current: float, maximum: float) -> void:
	stamina_bar.max_value = maximum
	stamina_bar.value = current

	stamina_bar.visible = current < maximum
