extends UIState

@onready var race_button: Button = %RaceButton
@onready var info_button: Button = %InfoButton
@onready var exit_button: Button = %ExitButton
@onready var info_menu_uid: String = "uid://dp6d5y1bceddg"
@onready var how_to_play_window: = preload("uid://cr8hhutactn1a")
@onready var sfx: Node = %SFX

var accept_input : bool = true

func _ready() -> void:
	Events.on_how_to_play.connect(_toggle_main_menu_input)
	
	# find every button and assign audio on its focus entered
	for button in find_children("*", "Button"):
		button.focus_entered.connect(sfx.play_ui_up)
		button.pressed.connect(sfx.play_ui_select)


func _input(event: InputEvent) -> void:
	if ui_root.current_state != ui_root.State.MAIN_MENU:
		return
	
	if !accept_input:
		return
	
	for player : PlayerDefinition in GameManager.player_list:
		if race_button.has_focus():
			if event.is_action_pressed(player.controls.actions["forward"]):
				race_button.pressed.emit()
		
		if info_button.has_focus():
			if event.is_action_pressed(player.controls.actions["forward"]):
				info_button.pressed.emit()
				GameManager.load_into_path(info_menu_uid, 1)
			
		if exit_button.has_focus():
			if event.is_action_pressed(player.controls.actions["forward"]):
				exit_button.pressed.emit()
				get_tree().quit()
		
		if Input.is_action_just_pressed(player.controls.actions["leave"]):
			GameManager.remove_player(player)
		
func _toggle_main_menu_input(how_to_play_open : bool) -> void:
	accept_input = how_to_play_open
	race_button.disabled = !how_to_play_open
	info_button.disabled = !how_to_play_open
	exit_button.disabled = !how_to_play_open
