extends Node

@onready var intro: AudioStreamPlayer = $Intro
@onready var loop: AudioStreamPlayer = $Loop

func _ready() -> void:
	Events.on_countdown_finished.connect(_play_intro)

func _play_intro() -> void:
	if intro.stream:
		intro.play()
	else:
		loop.play()


func _on_intro_finished() -> void:
	intro.stop()
	loop.play()
