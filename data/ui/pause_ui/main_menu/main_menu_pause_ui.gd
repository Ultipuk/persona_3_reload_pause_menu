extends Control

const FIRST_SELECTION_IDX = 0
const LAST_SELECTION_IDX = 8

signal submenu_selected(index: int)


@export_range(FIRST_SELECTION_IDX, LAST_SELECTION_IDX, 1) var selected_idx: int = 0 :
	set(new_selected_idx):
		handle_selection_update(selected_idx, new_selected_idx)
		selected_idx = new_selected_idx

@onready var cursor: UiMainMenuCursor = $TriangleCursor
@onready var index: Label = $MenuInfo/MenuIndex
@onready var options: Array[UiMainMenuOption] = [
	$Options/SubViewport/Options/Skill,
	$Options/SubViewport/Options/Item,
	$Options/SubViewport/Options/Equip,
	$Options/SubViewport/Options/Persona,
	$Options/SubViewport/Options/Stats,
	$Options/SubViewport/Options/Quest,
	$Options/SubViewport/Options/SocialLink,
	$Options/SubViewport/Options/Calendar,
	$Options/SubViewport/Options/System
]
@onready var cursor_dummy: UiMainMenuOption = $Options/SubViewport/Options/CURSOR_DUMMY

@onready var character_animation_player: AnimationPlayer = $Character/SubViewport/Scene/AnimationPlayer
@onready var tooltip_ui: TooltipUI = $TooltipUI
@onready var body: MeshInstance3D = $Character/SubViewport/Scene/Makoto/Skeleton3D/Body
@onready var background: TextureRect = $Background


@export var background_ui_viewport: SubViewport


func _ready() -> void:
	options[selected_idx].select()
	background.texture = background_ui_viewport.get_texture()
	body.material_override.set_shader_parameter("background_texture", background_ui_viewport.get_texture())


func open() -> void:
	show()
	swing()
	move_cursor(options[selected_idx])


func open_first_time() -> void:
	selected_idx = 0
	show()
	fall()
	open_options()
	spawn_cursor()


func fall() -> void:
	character_animation_player.play("UI_MAIN_fall")
	get_tree().create_timer(0.4).timeout.connect(swing)

func swing() -> void:
	character_animation_player.play("UI_MAIN_swing")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		UISFX.play_move()
		select_next()
	
	elif event.is_action_pressed("ui_up"):
		UISFX.play_move()
		select_prev()
	
	elif event.is_action_pressed("ui_select"):
		UISFX.play_select()
		submenu_selected.emit(selected_idx)


func select_prev() -> void:
	selected_idx = LAST_SELECTION_IDX if selected_idx <= FIRST_SELECTION_IDX else selected_idx - 1


func select_next() -> void:
	selected_idx = FIRST_SELECTION_IDX if selected_idx >= LAST_SELECTION_IDX else selected_idx + 1


func handle_selection_update(prev_idx: int, new_idx: int) -> void:
	options[prev_idx].unselect()
	options[new_idx].select()
	
	index.text = "%d" % (new_idx + 1)
	tooltip_ui.title = [
		"Use a Skill",
		"View / Use Items",
		"View / Change Equipment",
		"View / Change Personas",
		"View Stats / Organize Party",
		"View Requests",
		"View Social Links",
		"View Calendar",
		"View Settings",
	][new_idx]
	
	move_cursor(options[new_idx])


func move_cursor(option: Control) -> void:
	cursor.attach_to_option(option)


func spawn_cursor() -> void:
	get_tree().create_timer(0.4).timeout.connect(func():
		cursor.show()
		cursor.spawn_at_option(cursor_dummy)
	)


func open_options() -> void:
	var tween := get_tree().create_tween()
	
	for i in options.size():
		var option := options[i]
		var delay := (options.size() - 1 - i) / 30.
		tween.parallel().tween_callback(option.spawn).set_delay(delay)


func close() -> void:
	for option in options:
		option.hide()
	cursor.hide()
