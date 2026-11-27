extends CanvasLayer
@onready var true_button: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer/TrueButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	true_button.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
