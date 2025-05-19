extends Node

@onready var pause_ui: Control = $PauseContainer/SubViewport/PauseUI
@onready var pause_container: SubViewportContainer = $PauseContainer



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if pause_ui.in_main_menu:
			pause_ui.close()
			
			var tween := create_tween()
			tween.tween_method(pause_ui_transition_progress, 0.0, 1.0, 0.2)
			tween.chain().tween_callback(pause_container.hide)
		
		elif not pause_container.visible:
			pause_ui_transition_progress(0.0)
			$PauseContainer.show()
			pause_ui.open()
			

func pause_ui_transition_progress(progress: float) -> void:
	pause_container.material.set_shader_parameter("progress", progress)
