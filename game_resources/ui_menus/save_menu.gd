extends CanvasLayer

@onready var save_slot_1: Control = $Anchor/VBoxContainer/SaveSlot1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_slot_1.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
