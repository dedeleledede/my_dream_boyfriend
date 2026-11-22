
extends TextureButton
@export var texture_selected: Texture2D
@export var texture_idle: Texture2D
@export var button_text: String = "PLACEHOLDER"

@onready var label = $Label

func _ready() -> void:
	texture_normal = texture_idle
	texture_selected = texture_selected
	label.text = button_text
