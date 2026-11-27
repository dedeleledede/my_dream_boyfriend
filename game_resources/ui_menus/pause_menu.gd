extends CanvasLayer

@onready var default_focus: TextureButton = $Anchor/Panel/VBoxContainer/save/TextureButton

func _ready() -> void:
	default_focus.grab_focus()
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = false
		Game.set_state(Game.State.EXPLORATION)
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
