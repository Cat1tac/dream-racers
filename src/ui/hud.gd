class_name HUD extends Control

@onready var countdown: Label = %Countdown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.on_get_countdown.connect(_update_countdown_text)
	Events.on_countdown_finished.connect(_countdown_finished)

func _update_countdown_text(num : int) -> void:
	countdown.text = str(num)
	
func _countdown_finished() -> void:
	countdown.text = "GO"
	await get_tree().create_timer(0.5).timeout
	countdown.text = " "
