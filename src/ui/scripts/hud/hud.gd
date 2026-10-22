class_name HUD extends Control

@onready var countdown: Label = %Countdown
@onready var results_screen: PackedScene = preload("uid://cj6n40p2vgfo7")
var instantiated_results_screen: ResultsScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_results_screen: ResultsScreen = results_screen.instantiate()
	add_child(new_results_screen)
	new_results_screen.hide_results_screen()
	instantiated_results_screen = new_results_screen
	
	Events.on_get_countdown.connect(_update_countdown_text)
	Events.on_countdown_finished.connect(_countdown_finished)
	Events.on_race_over.connect(_race_over)

## NOTE DEBUG
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_1):
		Events.on_race_over.emit()

func _update_countdown_text(num : int) -> void:
	countdown.text = str(num)
	
func _countdown_finished() -> void:
	countdown.text = "GO"
	await get_tree().create_timer(0.5).timeout
	countdown.text = " "

func _race_over() -> void:
	countdown.text = "Finish"
	await get_tree().create_timer(1).timeout
	countdown.text = " "
	
	await get_tree().create_timer(1).timeout
	instantiated_results_screen.show_results_screen()
	## RESULTS SCREEN GOES HERE
	
