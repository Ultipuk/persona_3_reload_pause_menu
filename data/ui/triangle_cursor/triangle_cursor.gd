@tool
extends Node2D
class_name UiMainMenuCursor


@onready var timer: Timer = $Timer

@export_range(1.0, 1.5, 0.01) var twitch_scale := 1.15
@export_range(0.0, 5.0, 0.01, "suffix:sec") var twitch_period := 1.2
@export_range(0.0, 1.0, 0.001, "suffix:sec") var twitch_duration := 0.2

@export var offset: Vector2 = Vector2.ONE :
	set(v):
		offset = v
		if is_node_ready():
			front_polygon.position = back_polygon.position + offset
@export_range(-180.0, 180.0, 0.01, "suffix:deg") var angle: float = 0.0 :
	set(v):
		angle = v
		if is_node_ready():
			front_polygon.rotation_degrees = back_polygon.rotation_degrees + angle

@onready var back_polygon: Polygon2D = $BackPolygon
@onready var front_polygon: Polygon2D = $FrontPolygon

@export var sub_viewport_texture: SubViewport :
	set(v):
		sub_viewport_texture = v
		
		if is_node_ready():
			if sub_viewport_texture:
				var texture := sub_viewport_texture.get_texture()
				back_polygon.material.set_shader_parameter("text_viewport_texture", texture)
				front_polygon.material.set_shader_parameter("text_viewport_texture", texture)
			else:
				back_polygon.material.set_shader_parameter("text_viewport_texture", null)
				front_polygon.material.set_shader_parameter("text_viewport_texture", null)


var twitch_tween: Tween
var cursor_moving_tween: Tween


func _ready() -> void:
	if sub_viewport_texture:
		var texture := sub_viewport_texture.get_texture()
		back_polygon.material.set_shader_parameter("text_viewport_texture", texture)
		front_polygon.material.set_shader_parameter("text_viewport_texture", texture)


func attach_to_option(option: Control) -> void:
	twitch()
	
	var new_transform := option.get_transform().translated(option.pivot_offset.rotated(option.rotation))
	
	if cursor_moving_tween: cursor_moving_tween.kill()
	cursor_moving_tween = create_tween()
	
	cursor_moving_tween.tween_property(self, "transform", new_transform, 0.06)
	cursor_moving_tween.parallel().tween_property(self, "scale", Vector2(option.size.x / 150.0, option.size.y / 50.0), 0.06)
	cursor_moving_tween.parallel().tween_property(self, "angle", -option.rotation_degrees * 0.16, 0.06)


func twitch() -> void:
	timer.start(1.0)
	
	if twitch_tween: twitch_tween.kill()
	twitch_tween = create_tween()
	
	twitch_tween.tween_property(front_polygon, "scale", Vector2.ONE * twitch_scale, twitch_duration * 0.5)
	twitch_tween.chain().tween_property(front_polygon, "scale", Vector2.ONE, twitch_duration * 0.5)


func spawn_at_option(option: UiMainMenuOption) -> void:
	var final_transform := option.get_transform().translated(option.pivot_offset.rotated(option.rotation))
	cursor_moving_tween = create_tween()
	
	transform = final_transform
	cursor_moving_tween.set_trans(Tween.TRANS_CIRC)
	
	var offset_1 := final_transform.origin + Vector2(1., -1.) * 40.0
	var offset_2 := final_transform.origin - Vector2(1., -1.) * 20.0
	var offset_3 := final_transform.origin + Vector2(1., -1.) * 10.0
	var offset_4 := final_transform.origin
	
	position = offset_1
	scale = Vector2(option.size.x / 150.0, option.size.y / 50.0)
	angle = -option.rotation_degrees * 0.16
	
	cursor_moving_tween.tween_property(self, "position", offset_2, 0.2)
	cursor_moving_tween.chain().tween_property(self, "position", offset_3, 0.1)
	cursor_moving_tween.chain().tween_property(self, "position", offset_4, 0.1)
