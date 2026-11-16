class_name DialogueLine
extends Resource

@export var who: String = ""
@export_multiline var what: String = ""

@export_group("Visual")
@export var portrait: Texture2D
@export var cg: Texture2D
@export var style_id: StringName = &"default"
