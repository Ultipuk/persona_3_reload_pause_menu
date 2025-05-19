@tool
extends Control
class_name TooltipUI

const TRAILING_LINE = " ────────────────────────────────────────────────────────────────────────────"

@onready var title_label: Label = $Title
@onready var sub_title_label: Label = $SubTitle

@export var title: String = "Title" :
	set(v):
		title = v
		if is_node_ready():
			var previous_size := title_label.size
			title_label.text = title
			# Forcefully recalculate container with new title text.
			# Otherwise, node size will be recalculated later.
			title_label.reset_size()
			_recalculate_titles_position(previous_size)
@export var sub_title: String = "Sub" :
	set(v):
		sub_title = v
		if is_node_ready():
			sub_title_label.text = sub_title + TRAILING_LINE


func _recalculate_titles_position(previous_size: Vector2) -> void:
	title_label.position = title_label.position + previous_size - title_label.size
	sub_title_label.position = title_label.position + Vector2(0.0, title_label.size.y)
	sub_title_label.size = Vector2(-sub_title_label.position.x, title_label.size.y)


func _ready() -> void:
	title = title
	sub_title = sub_title
