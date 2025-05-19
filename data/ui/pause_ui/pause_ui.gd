extends Control


@onready var frame_1_mask: TextureRect = $Frames/Frame1Mask
@onready var frame_1: TextureRect = $Frames/Frame1
@onready var frame_2_mask: TextureRect = $Frames/Frame2Mask
@onready var frame_2: TextureRect = $Frames/Frame2
@onready var frame_3_mask: TextureRect = $Frames/Frame3Mask
@onready var frame_3: TextureRect = $Frames/Frame3
@onready var frame_4_mask: TextureRect = $Frames/Frame4Mask
@onready var frame_4: TextureRect = $Frames/Frame4
@onready var frame_5_mask: TextureRect = $Frames/Frame5Mask
@onready var frame_5: TextureRect = $Frames/Frame5
@onready var frame_6: TextureRect = $Frames/Frame6
@onready var frame_7: TextureRect = $Frames/Frame7
@onready var frame_8: TextureRect = $Frames/Frame8
@onready var frame_9: TextureRect = $Frames/Frame9
@onready var frame_10: TextureRect = $Frames/Frame10

@onready var main_menu_pause_ui: Control = $MainMenu/SubViewport/MainMenuPauseUI
@onready var blot_transition: ColorRect = $MainMenu/SubViewport/BlotTransition

@onready var main_menu_sub_viewport_container: SubViewportContainer = $MainMenu
@onready var item_menu_sub_viewport_container: SubViewportContainer = $ItemMenu

@onready var sub_menu_sub_viewport_containers: Array[Control] = [
	$ItemMenu,
	$ItemMenu,
	$ItemMenu,
	$ItemMenu,
	$ItemMenu,
	$ItemMenu,
	$ItemMenu,
	$ItemMenu,
	$ItemMenu,
]

@onready var sub_menus: Array[Control] = [
	$ItemMenu/SubViewport/ItemMenuPauseUI,
	$ItemMenu/SubViewport/ItemMenuPauseUI,
	$ItemMenu/SubViewport/ItemMenuPauseUI,
	$ItemMenu/SubViewport/ItemMenuPauseUI,
	$ItemMenu/SubViewport/ItemMenuPauseUI,
	$ItemMenu/SubViewport/ItemMenuPauseUI,
	$ItemMenu/SubViewport/ItemMenuPauseUI,
	$ItemMenu/SubViewport/ItemMenuPauseUI,
	$ItemMenu/SubViewport/ItemMenuPauseUI,
]
@onready var background_pause_ui: BackgroundPauseUI = $Background/SubViewport/BackgroundPauseUI

@export var openning_frame_duration := 3. / 60.
@export var game_viewport: SubViewport


var menu_transition_tween: Tween
var in_main_menu := false


func _ready() -> void:
	reset()


func reset() -> void:
	hide()
	
	main_menu_pause_ui.set_process(false)
	main_menu_pause_ui.set_process_input(false)
	
	for menu in sub_menus:
		menu.set_process(false)
		menu.set_process_input(false)
	
	main_menu_sub_viewport_container.hide()
	
	for container in sub_menu_sub_viewport_containers:
		container.hide()
	
	background_pause_ui.texture = game_viewport.get_texture()
	frame_1_mask.material.set_shader_parameter("texture_2", game_viewport.get_texture())
	frame_2_mask.material.set_shader_parameter("texture_2", game_viewport.get_texture())
	frame_3_mask.material.set_shader_parameter("texture_2", game_viewport.get_texture())
	frame_4_mask.material.set_shader_parameter("texture_2", game_viewport.get_texture())
	frame_5_mask.material.set_shader_parameter("texture_2", game_viewport.get_texture())


func open() -> void:
	show()
	$"../../../WorldContainer/SubViewport".render_target_update_mode = SubViewport.UpdateMode.UPDATE_DISABLED
	show_frames()
	open_main_menu_first_time()
	UISFX.play_open_pause()


func close() -> void:
	UISFX.play_cancel()
	close_main_menu()


func show_frames() -> void:
	var tween := create_tween()
	
	tween.tween_callback(func():
		frame_1_mask.visible = true
		frame_1.visible = true
	)
	
	tween.chain().tween_callback(func():
		frame_1_mask.visible = false
		frame_1.visible = false
		frame_2_mask.visible = true
		frame_2.visible = true
	).set_delay(openning_frame_duration)
	
	tween.chain().tween_callback(func():
		frame_2_mask.visible = false
		frame_2.visible = false
		frame_3_mask.visible = true
		frame_3.visible = true
	).set_delay(openning_frame_duration)
	
	tween.chain().tween_callback(func():
		frame_3_mask.visible = false
		frame_3.visible = false
		frame_4_mask.visible = true
		frame_4.visible = true
	).set_delay(openning_frame_duration)
	
	tween.chain().tween_callback(func():
		frame_4_mask.visible = false
		frame_4.visible = false
		frame_5_mask.visible = true
		frame_5.visible = true
	).set_delay(openning_frame_duration)
	
	tween.chain().tween_callback(func():
		frame_5_mask.visible = false
		frame_5.visible = false
		frame_6.visible = true
	).set_delay(openning_frame_duration)
	
	tween.chain().tween_callback(func():
		frame_6.visible = false
		frame_7.visible = true
	).set_delay(openning_frame_duration)
	
	tween.chain().tween_callback(func():
		frame_7.visible = false
		frame_8.visible = true
	).set_delay(openning_frame_duration)
	
	tween.chain().tween_callback(func():
		frame_8.visible = false
		frame_9.visible = true
	).set_delay(openning_frame_duration)
	
	tween.chain().tween_callback(func():
		frame_9.visible = false
		frame_10.visible = true
	).set_delay(openning_frame_duration)
	
	tween.chain().tween_callback(func():
		frame_10.visible = false
	).set_delay(openning_frame_duration)


func open_main_menu() -> void:
	main_menu_pause_ui.set_process(true)
	main_menu_pause_ui.set_process_input(true)
	
	main_menu_pause_ui.open()
	main_menu_sub_viewport_container.show()
	
	in_main_menu = true


func open_main_menu_first_time() -> void:
	main_menu_pause_ui.set_process(true)
	main_menu_pause_ui.set_process_input(true)
	
	main_menu_pause_ui.open_first_time()
	main_menu_sub_viewport_container.show()
	
	in_main_menu = true


func open_sub_menu(sub_menu: Control) -> void:
	sub_menu.set_process(true)
	sub_menu.set_process_input(true)
	
	main_menu_pause_ui.set_process(false)
	main_menu_pause_ui.set_process_input(false)
	
	in_main_menu = false


func close_main_menu() -> void:
	main_menu_pause_ui.close()
	
	main_menu_pause_ui.set_process(false)
	main_menu_pause_ui.set_process_input(false)
	
	in_main_menu = false


func sub_menu_transition_open(sub_menu_sub_viewport_container: SubViewportContainer) -> void:
	if menu_transition_tween: menu_transition_tween.kill()
	menu_transition_tween = create_tween()
	
	sub_menu_sub_viewport_container.show()
	sub_menu_transition_progress(0.0, sub_menu_sub_viewport_container)
	
	menu_transition_tween.tween_method(
		blot_transition_progress, 0.1, 1.0, 0.3)
	menu_transition_tween.parallel().tween_method(
		sub_menu_transition_progress.bind(sub_menu_sub_viewport_container), 0.0, 1.0, 0.2).set_delay(0.15)
	menu_transition_tween.chain().tween_callback(main_menu_sub_viewport_container.hide)


func sub_menu_transition_close(sub_menu_sub_viewport_container: SubViewportContainer) -> void:
	if menu_transition_tween: menu_transition_tween.kill()
	menu_transition_tween = create_tween()
	
	main_menu_sub_viewport_container.z_index = 10
	main_menu_sub_viewport_container.show()
	blot_transition_progress(0.0)
	
	menu_transition_tween.tween_method(main_menu_transition_progress, 0.1, 1.0, 0.3)
	menu_transition_tween.chain().tween_callback(sub_menu_sub_viewport_container.hide)
	menu_transition_tween.chain().tween_callback(func(): main_menu_sub_viewport_container.z_index = 0)


func close_sub_menu(sub_menu: Control) -> void:
	sub_menu.set_process(false)
	sub_menu.set_process_input(false)
	
	main_menu_pause_ui.set_process(true)
	main_menu_pause_ui.set_process_input(true)
	
	in_main_menu = true


func sub_menu_transition_progress(progress: float, sub_menu: SubViewportContainer) -> void:
	sub_menu.material.set_shader_parameter("progress", progress)


func blot_transition_progress(progress: float) -> void:
	blot_transition.material.set_shader_parameter("progress", progress)


func main_menu_transition_progress(progress: float) -> void:
	main_menu_sub_viewport_container.material.set_shader_parameter("progress", progress)


func _on_main_menu_pause_ui_submenu_selected(index: int) -> void:
	open_sub_menu(sub_menus[index])
	sub_menu_transition_open(sub_menu_sub_viewport_containers[index])
