extends UIState

@onready var race_button: Button = %RaceButton
@onready var how_to_play_button: Button = %HowToPlayButton
@onready var exit_button: Button = %ExitButton
@onready var how_to_play_window: = preload("uid://cr8hhutactn1a")

var accept_input : bool = true

func _ready() -> void:
	Events.on_how_to_play.connect(_toggle_main_menu_input)

func _input(event: InputEvent) -> void:
	if ui_root.current_state != ui_root.State.MAIN_MENU:
		return
	
	if !accept_input:
		return
	
	for player : PlayerDefinition in GameManager.player_list:
		if race_button.has_focus():
			if event.is_action(player.controls.actions["forward"]):
				race_button.pressed.emit()
		
		if how_to_play_button.has_focus():
			if event.is_action(player.controls.actions["forward"]):
				print("yo")
				var window_instance : TabContainer = how_to_play_window.instantiate()
				get_child(0).add_child(window_instance)
			
		if exit_button.has_focus():
			if event.is_action(player.controls.actions["forward"]):
				get_tree().quit()
		
func _toggle_main_menu_input(how_to_play_open : bool) -> void:
	accept_input = how_to_play_open
	race_button.disabled = !how_to_play_open
	how_to_play_button.disabled = !how_to_play_open
	exit_button.disabled = !how_to_play_open
