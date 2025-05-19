@tool
extends Control
class_name BackgroundPauseUI

@onready var texture_rect: TextureRect = $SubViewportContainer/SubViewport/TextureRect
@export var texture: Texture2D :
	set(v):
		texture = v
		if is_node_ready(): texture_rect.texture = texture


func _ready() -> void:
	texture = texture
