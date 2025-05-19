@tool
extends Label
class_name UiMainMenuOption

const UI_TEXT_RIPPLES = preload("res://assets/materials/ui_text_ripples.material")

@export var base_color: Color :
	set(v):
		base_color = v

var saved_default_scale := Vector2.ONE
var saved_default_z_index := 0

var tween_when_selected: Tween
var spawning_tween: Tween


func _ready() -> void:
	pivot_offset = size * 0.5
	if not Engine.is_editor_hint(): hide()


func spawn() -> void:
	show()
	
	var saved_position := position
	
	var current_color := get_theme_color("font_color")
	var transperent_color: Color = (func(c): c.a = 0.0; return c).call(current_color)
	
	set_font_collor(transperent_color)
	position += Vector2.UP * 30.0
	
	if tween_when_selected: tween_when_selected.kill()
	tween_when_selected = create_tween()
	tween_when_selected.tween_method(set_font_collor, transperent_color, current_color, 0.4)

	if spawning_tween: spawning_tween.kill()
	spawning_tween = create_tween()
	spawning_tween.tween_property(self, "position", saved_position, 0.4)


func select() -> void:
	if tween_when_selected: tween_when_selected.kill()
	
	saved_default_scale = scale
	saved_default_z_index = z_index
	
	tween_when_selected = create_tween()
	tween_when_selected.set_trans(Tween.TRANS_BACK)
	
	z_index = 1
	set_font_collor(Color.BLACK)
	tween_when_selected.tween_property(self, "scale", scale * 1.5, 0.1)
	material = null


func unselect() -> void:
	if tween_when_selected: tween_when_selected.kill()
	
	scale = saved_default_scale
	z_index = saved_default_z_index
	set_font_collor(base_color)
	material = UI_TEXT_RIPPLES


func set_font_collor(color: Color) -> void:
	add_theme_color_override("font_color", color)
