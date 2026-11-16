extends CanvasLayer

@onready var default_focus: TextureButton = $Panel/VBoxContainer/save/TextureButton

func _ready() -> void:
	default_focus.grab_focus()
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = false
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
