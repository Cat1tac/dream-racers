extends UIState

@export var character_buttons : Array[TextureButton]
@export var character_models : Array[PackedScene]
@export var character_views : Array[CharacterView]
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
	next_button.grab_focus()
	transition_animations.play("next_button_pop_in")

func _input(event: InputEvent) -> void:
	#TODO make it work with multiple players by checking which player is hovered over x character 
	# Could probably wwork by reading each individual players input and using that to over n stuff  like have p1_right and p2_right
	if !visible:
		return
		
	if event.is_action("ui_right") or event.is_action("ui_left") or event.is_action("ui_accept"):
		pass
	else:
		return 
		
	for i in range(len(character_buttons)):
		# For hovering
		if character_buttons[i].has_focus() and !character_buttons[i].button_pressed:
			if i > len(character_models) - 1: # Checks to make sure game isn't trying to access a out of bounds element
				character_views[0].remove_model_in_viewport()
				break
			if character_models[i] == character_views[0].current_model_packed_scene: # Makes sure game doesnt load the model a second time
				continue
			var model_instance := character_models[i].instantiate() as Model
			character_views[0].set_model_in_viewport(model_instance)
			character_views[0].current_model_packed_scene = character_models[i]
			model_instance.current_state = model_instance.STATE.IN_CHARACTER_SELECT
			model_instance.selected = false
		# For Pressed
		elif character_buttons[i].button_pressed:
			if i > len(character_models) - 1:
				continue
			character_views[0].model_instance.selected = true
			
		

	
	
