extends Node

var current_state: State = State.NONE
@onready var main_menu: UIState = %MainMenu
@onready var character_select: UIState = %CharacterSelect
@onready var track_select: UIState = %TrackSelect

@onready var race_button: Button = $UILayer/MainMenu/VBoxContainer/ButtonMargin/ButtonVBox/RaceButton
@onready var character_1: TextureButton = $UILayer/CharacterSelect/VBoxContainer/CharacterPortraitMargin/CharacterPortraitHBox/CharFrame1/Character1
@onready var track_1_button: TextureButton = $UILayer/TrackSelect/VBoxContainer/TrackViewMargin/TrackViewHBox/Track1/Track1Button

@onready var main_music: AudioStreamPlayer = $MainMusic
var music_time: float # offset of transisions
var music_stage_start: float = 0.0
var music_stage_end: float = 0.0
var seconds_per_beat:= 60.0/170.0 # used for precise timing calculations

## defined states that the UI can be in
enum State {
	NONE, 
	MAIN_MENU, 
	CHAR_SELECT, 
	TRACK_SELECT,
	}

# TODO set & auto detect what UI state is active based on which is visible
func _ready() -> void:
	main_music.play()
	switch_music_stage(1)
	if main_menu.visible:
		current_state = State.MAIN_MENU
		main_menu.set_initial_focus(race_button)

#region forward transitions
func _race_button_pressed() -> void:
	current_state = State.CHAR_SELECT
	main_menu.transition_to_state(character_select)
	character_select.set_initial_focus(character_1)
	switch_music_stage(2)

func _character_next_button_pressed() -> void:
	current_state = State.TRACK_SELECT
	character_select.transition_to_state(track_select)
	track_select.set_initial_focus(track_1_button)
	switch_music_stage(3)
	
	
func _track_next_button_pressed() -> void:
	main_music.stop()
	GameManager.load_into_main_game()

#endregion

#region back transitions
func _char_back_button_pressed() -> void:
	current_state = State.MAIN_MENU
	character_select.transition_to_state(main_menu)
	main_menu.set_initial_focus(race_button)
	switch_music_stage(1)

func _track_back_button_pressed() -> void:
	current_state = State.CHAR_SELECT
	track_select.transition_to_state(character_select)
	character_select.set_initial_focus(character_1)
	switch_music_stage(2)
#endregion

#region music

# tracks time within sections to transition seamlessly
func _process(delta: float) -> void:
	music_time += delta
	if main_music.get_playback_position() >= music_stage_end:
		print("Audio: Loop End Passed")
		music_time = 0
		main_music.play(music_stage_start)

# transitions to each section of the main theme depending on UI state
func switch_music_stage(state: int) -> void:
	match state:
		1:
			music_stage_start = 0.0 
			music_stage_end = 64 * seconds_per_beat
		2:
			music_stage_start = 64 * seconds_per_beat
			music_stage_end = 128 * seconds_per_beat
		3:
			music_stage_start = 128 * seconds_per_beat
			music_stage_end = 192 * seconds_per_beat
		_:
			print("AudioError: Swapped to an Undefined stage")
	
	main_music.play(music_stage_start + music_time)

#endregion

func _exit_button_pressed() -> void:
	get_tree().quit()
