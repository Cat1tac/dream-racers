extends Node

var current_state: State = State.NONE
@onready var main_menu: UIState = %MainMenu
@onready var character_select: UIState = %CharacterSelect
@onready var track_select: UIState = %TrackSelect

@onready var race_button: Button = $UILayer/MainMenu/VBoxContainer/ButtonMargin/ButtonVBox/RaceButton
@onready var character_1: TextureButton = $UILayer/CharacterSelect/VBoxContainer/CharacterPortraitMargin/CharacterPortraitHBox/CharFrame1/Character1
@onready var track_1_button: TextureButton = $UILayer/TrackSelect/VBoxContainer/TrackViewMargin/TrackViewHBox/Track1/Track1Button

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

#region forward transitions
func _race_button_pressed() -> void:
	current_state = State.CHAR_SELECT
	main_menu.transition_to_state(character_select)
	character_select.set_initial_focus(character_1)

func _character_next_button_pressed() -> void:
	current_state = State.TRACK_SELECT
	character_select.transition_to_state(track_select)
	track_select.set_initial_focus(track_1_button)
	
	
func _track_next_button_pressed() -> void:
	GameManager.load_into_main_game()

#endregion

#region back transitions
func _char_back_button_pressed() -> void:
	current_state = State.MAIN_MENU
	character_select.transition_to_state(main_menu)
	main_menu.set_initial_focus(race_button)

func _track_back_button_pressed() -> void:
	current_state = State.CHAR_SELECT
	track_select.transition_to_state(character_select)
	character_select.set_initial_focus(character_1)
#endregion

func _exit_button_pressed() -> void:
	get_tree().quit()
