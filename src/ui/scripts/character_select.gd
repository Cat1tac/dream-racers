extends UIState
#TODO when first going into character select screen make the game show the character being hovered over initially
@export var character_buttons : Array[TextureButton]
@export var charater_models : Array[PackedScene]
@export var character_views : Array[CharacterView]
@onready var next_button: Button = $NextButtonMargin/NextButton

func _ready() -> void:
	Events.on_player_added.connect(_show_character)
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

## Show the character on initial viibility
func _on_visibility_changed() -> void:
	_character_view_visibility_toggle()
	for player : PlayerDefinition in GameManager.player_list:
		_show_character(player.character_select_position, player.id)

func _show_next_button() -> void:
	if next_button.visible:
		return
	next_button.show()
	transition_animations.play("next_button_pop_in")

func _input(event: InputEvent) -> void:
	if !visible:
		return
	
	for player : PlayerDefinition in GameManager.player_list:
		if (event.is_action(player.controls.ui_right)
		or event.is_action(player.controls.ui_left) 
		or event.is_action(player.controls.ui_select)
		or event.is_action(player.controls.ui_deselect)):
			_player_behavior_on_character_select(player)
	
func _player_behavior_on_character_select(player : PlayerDefinition) -> void:
	# Moving left a right on character select
	if !player.character_select_pressed and (Input.is_action_just_pressed(player.controls.ui_right) or Input.is_action_just_pressed(player.controls.ui_left)):
		character_views[player.id].remove_model_in_viewport() #Removes previous model in view if theres one
		
		if Input.is_action_just_pressed(player.controls.ui_right):
			player.character_select_position += 1
		elif Input.is_action_just_pressed(player.controls.ui_left):
			player.character_select_position -= 1
			
		player.character_select_position = _keep_player_character_select_position_in_range(player.character_select_position)
		print("Player: ", player.id, "\nPosition: ", player.character_select_position)
		
		if player.character_select_position < len(charater_models):
			_show_character(player.character_select_position, player.id)
		
	# Selecting Character
	if Input.is_action_just_pressed(player.controls.ui_select) and !player.character_select_pressed:
		if character_views[player.id].model_instance: 
			player.character_select_pressed = true
			character_views[player.id].model_instance.selected = true
		
	# Deselecting Character
	if Input.is_action_just_pressed(player.controls.ui_deselect) and player.character_select_pressed:
		if character_views[player.id].model_instance: 
			player.character_select_pressed = false
			character_views[player.id].model_instance.selected = false

## Clamps cursor between 0 and num of character buttons 
func _keep_player_character_select_position_in_range(cursor_position : int) -> int:
	var new_position := cursor_position
	if cursor_position == len(character_buttons):
		new_position = 0
	elif cursor_position < 0:
		new_position = len(character_buttons) -1 
	return new_position

func _change_texture_box_outline(player : PlayerDefinition) -> void:
	pass

## Displays character in character view
func _show_character(select_position : int, id : int, player_added : bool = false) -> void:
	if !visible:
		return
	if player_added:
		_character_view_visibility_toggle()
		
	var model_instance := charater_models[select_position].instantiate() as Model
	character_views[id].set_model_in_viewport(model_instance, id)
	character_views[id].current_model_packed_scene = charater_models[select_position]
	model_instance.current_state = model_instance.STATE.IN_CHARACTER_SELECT
	model_instance.selected = false

func _character_view_visibility_toggle() -> void:
	for views in character_views:
		if character_views.find(views) < GameManager.players_connected:
			views.visible = true
		else: 
			views.visible = false
