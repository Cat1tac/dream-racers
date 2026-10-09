extends Node

@onready var intro: AudioStreamPlayer = $Intro
@onready var loop: AudioStreamPlayer = $Loop


func _on_testtrack_1_countdown_finished() -> void:
	intro.play()


func _on_intro_finished() -> void:
	intro.stop()
	loop.play()
