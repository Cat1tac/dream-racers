extends Node

@onready var intro: AudioStreamPlayer = $Intro
@onready var loop: AudioStreamPlayer = $Loop

func _ready() -> void:
	Events.on_countdown_finished.connect(_play_intro)

func _play_intro(delay : int) -> void:
	await get_tree().create_timer((delay * 60 * get_process_delta_time()) / 60).timeout
	if intro.stream:
		intro.play()
	else:
		loop.play()


func _on_intro_finished() -> void:
	intro.stop()
	loop.play()
