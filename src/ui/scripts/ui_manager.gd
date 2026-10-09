class_name UIManager extends Node

var current_state: State = State.NONE
@onready var main_menu: UIState = %MainMenu
@onready var character_select: UIState = %CharacterSelect
@onready var track_select: UIState = %TrackSelect
@onready var how_to_play_window: = preload("uid://cr8hhutactn1a")

@onready var race_button: Button = $UILayer/MainMenu/VBoxContainer/ButtonMargin/ButtonVBox/RaceButton
@onready var track_icon_1: TextureButton = $UILayer/TrackSelect/VBoxContainer/TrackViewMargin/TrackViewHBox/TrackIcon1/TrackButton

var is_transitioning: bool

## defined states that the UI can be in
enum State {
	NONE, 
	MAIN_MENU, 
	CHAR_SELECT, 
	TRACK_SELECT,
	}

# TODO set & auto detect what UI state is active based on which is visible
func _ready() -> void:
	if main_menu.visible:
		current_state = State.MAIN_MENU
		main_menu.set_initial_focus(race_button)

func _how_to_play_button_pressed() -> void:
	var window_instance = how_to_play_window.instantiate()
	get_child(0).add_child(window_instance)

#region forward transitions
func _race_button_pressed() -> void:
	main_menu.transition_to_state(character_select)
	
	is_transitioning = true
	await main_menu.transition_finished
	is_transitioning = false
	
	current_state = State.CHAR_SELECT

func _character_next_button_pressed() -> void:
	character_select.transition_to_state(track_select)
	
	is_transitioning = true
	await character_select.transition_finished
	is_transitioning = false
	
	current_state = State.TRACK_SELECT
	track_select.set_initial_focus(track_icon_1)
	
func _track_next_button_pressed() -> void:
	GameManager.load_into_path("uid://dl7oklus7v6pk")

#endregion

#region back transitions
func _char_back_button_pressed() -> void:
	if is_transitioning:
		return
	character_select.transition_to_state(main_menu)
	
	is_transitioning = true
	await character_select.transition_finished
	is_transitioning = false
	
	current_state = State.MAIN_MENU
	main_menu.set_initial_focus(race_button)

func _track_back_button_pressed() -> void:
	if is_transitioning:
		return
	track_select.transition_to_state(character_select)
	
	is_transitioning = true
	await track_select.transition_finished
	is_transitioning = false
	
	current_state = State.CHAR_SELECT
	
#endregion

func _exit_button_pressed() -> void:
	get_tree().quit()

# supposed to consolidate transition flag logic but doesn't work rn
func transition_flag(state: UIState) -> void:
	is_transitioning = true
	await state.transition_finished
	is_transitioning = false
