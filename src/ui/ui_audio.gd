## Audio scene for ui sfx
extends Node

@export_group("UI SFX")
@export var ui_up : AudioStream
@export var ui_down : AudioStream
@export var ui_select : AudioStream
@export var ui_back : AudioStream

#@export_group("Ready SFX")
#@export var ready_in: AudioStream
#@export var ready_out: AudioStream

@export_group("Countdown SFX")
@export var countdown_tick : AudioStream
@export var countdown_go : AudioStream

@onready var ui: AudioStreamPlayer = $UI
@onready var ui_audio_player : AudioStreamPlaybackPolyphonic

func _ready() -> void:
	ui.play()
	ui_audio_player = ui.get_stream_playback()

#region UI
## utilizes AudioStreamPolyphonic to play streams of audio
func play_ui_audio(audio : AudioStream) -> void:
	if ui_audio_player:
		ui_audio_player.play_stream(audio)
	pass

func play_ui_up() -> void:
	play_ui_audio(ui_up)

func play_ui_down() -> void:
	play_ui_audio(ui_down)

func play_ui_select() -> void:
	play_ui_audio(ui_select)

func play_ui_back() -> void:
	play_ui_audio(ui_back)

#endregion

#region Countdown
func play_countdown_tick() -> void:
	play_ui_audio(countdown_tick)

func play_countdown_go() -> void:
	play_ui_audio(countdown_go)

#endregion
#func play_ready_in() -> void:
	#play_ui_audio(ready_in)
#
#func play_ready_out() -> void:
	#play_ui_audio(ready_out)
