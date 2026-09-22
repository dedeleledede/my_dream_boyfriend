class_name Interactable
extends Area2D

@export var interaction_text: String = "Interagir"

@onready var interaction_prompt: CanvasItem = get_node_or_null(
	"InteractionPrompt"
) as CanvasItem


func _ready() -> void:
	set_prompt_visible(false)


func can_interact(_player: Node) -> bool:
	return true


func interact(_player: Node) -> void:
	pass


func set_prompt_visible(value: bool) -> void:
	if interaction_prompt != null:
		interaction_prompt.visible = value
