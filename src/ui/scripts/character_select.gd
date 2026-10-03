extends UIState

@onready var next_button: Button = $NextButtonMargin/NextButton

func _ready() -> void:
	next_button.hide()
	GameManager.all_players_selected_character.connect(_show_next_button)

func _seraphim_pressed() -> void:
	GameManager.set_character(GameManager.SelectedCharacter.SERAPHIM)
	GameManager.validate_character_select()

func _nyx_pressed() -> void:
	GameManager.set_character(GameManager.SelectedCharacter.NYX)
	GameManager.validate_character_select()

func _muffin_pressed() -> void:
	GameManager.set_character(GameManager.SelectedCharacter.MUFFIN)
	GameManager.validate_character_select()

func _show_next_button() -> void:
	if next_button.visible:
		return
	next_button.show()
	transition_animations.play("next_button_pop_in")
