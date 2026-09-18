class_name Interactable
extends Area2D

@export var interaction_text: String = "Interagir"

func can_interact(_player: Node) -> bool:
	return true


func interact(_player: Node) -> void:
	pass
