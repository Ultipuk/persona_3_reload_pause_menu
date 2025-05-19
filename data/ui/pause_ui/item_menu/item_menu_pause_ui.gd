extends Control

@onready var background: TextureRect = $Background

@export var background_ui_viewport: SubViewport


func _ready() -> void:
	background.texture = background_ui_viewport.get_texture()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		UISFX.play_cancel()
		$"../../..".close_sub_menu(self)
		$"../../..".sub_menu_transition_close($"../..")
