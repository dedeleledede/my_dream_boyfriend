class_name Item
extends Resource

enum Type {
	KEY,
	INFORMATION,
	OTHER
}

@export var id: String
@export var name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var type: Type
@export var inspection_image: Texture2D
