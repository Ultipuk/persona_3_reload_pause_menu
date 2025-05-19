extends Node


@onready var select: AudioStreamPlayer = $Select
@onready var move: AudioStreamPlayer = $Move
@onready var cancel: AudioStreamPlayer = $Cancel
@onready var open_pause: AudioStreamPlayer = $OpenPause


func play_select() -> void:
	select.play()


func play_move() -> void:
	move.play()


func play_cancel() -> void:
	cancel.play()


func play_open_pause() -> void:
	open_pause.play()
