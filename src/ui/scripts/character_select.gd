extends UIState
#TODO when first going into character select screen make the game show the character being hovered over initially
@export var character_buttons : Array[CharacterButton]
@export var character_views : Array[CharacterView]
@onready var next_button: NavButton = $NextButtonMargin/NextButton
@onready var back_button: NavButton = $BackButtonMargin/BackButton

#TODO add way for player to leave game while on main menu (- on controller, spin key on keyboard)
#TODO make next button work by pressing ui_accept
#TODO make it so back button works by pressing right button on controllers and spin key on keyboard

func _ready() -> void:
	Events.on_player_added.connect(_show_character)
	self.visibility_changed.connect(_show_back_button)
	GameManager.all_players_selected_character.connect(_show_next_button)

## Show the character on initial visibility
func _on_visibility_changed() -> void:
	_character_view_visibility_toggle()
	for player : PlayerDefinition in GameManager.player_list:

		character_buttons[player.character_select_position].unhide_indicator(player.id)
		_show_character(player.character_select_position, player.id)

func _show_back_button() -> void:
	back_button.enter()
	
func _show_next_button(players_ready : bool) -> void:
	if players_ready:
		next_button.enter()
		next_button.grab_focus()
	else:
		next_button.exit()

func _input(event: InputEvent) -> void:
	if !visible:
		return
	if ui_root.current_state != ui_root.State.CHAR_SELECT:
		return
	
	for player : PlayerDefinition in GameManager.player_list:
		if (event.is_action(player.controls.ui_right)
		or event.is_action(player.controls.ui_left) 
		or event.is_action(player.controls.ui_select)
		or event.is_action(player.controls.ui_deselect)
		or event.is_action(player.controls.ui_next)):
			_player_behavior_on_character_select(player)
	
## Moving, select, and deselect
func _player_behavior_on_character_select(player : PlayerDefinition) -> void:
	# Moving left a right on character select
	if !player.character_select_pressed and (Input.is_action_just_pressed(player.controls.ui_right) or Input.is_action_just_pressed(player.controls.ui_left)):
		character_views[player.id].remove_model_in_viewport() #Removes previous model in view if theres one
		character_buttons[player.character_select_position].hide_indicator(player.id)
		
		if Input.is_action_just_pressed(player.controls.ui_right):
			player.character_select_position += 1
		elif Input.is_action_just_pressed(player.controls.ui_left):
			player.character_select_position -= 1
			
		player.character_select_position = _keep_player_character_select_position_in_range(player.character_select_position)
		character_buttons[player.character_select_position].unhide_indicator(player.id)
		
		if player.character_select_position < len(character_buttons) and character_buttons[player.character_select_position].character_model:
			_show_character(player.character_select_position, player.id)
		
	# Selecting Character
	if Input.is_action_just_pressed(player.controls.ui_select) and !player.character_select_pressed:
		if character_views[player.id].model_instance: 
			player.character_select_pressed = true
			character_views[player.id].model_instance.selected = true # Changes characters animation
			character_buttons[player.character_select_position].selected(player.id)
			GameManager.set_character(character_buttons[player.character_select_position].character_enum, player)
			GameManager.validate_character_select()
		
	# Deselecting Character
	if Input.is_action_just_pressed(player.controls.ui_deselect) and player.character_select_pressed:
		if character_views[player.id].model_instance: 
			player.character_select_pressed = false
			character_views[player.id].model_instance.selected = false # Changes characters animation
			character_buttons[player.character_select_position].unselect(player.id)
			GameManager.remove_character(player)
			GameManager.validate_character_select()
		
	# Return to Main Menu if no character selected 
	# BUG left or right and re-entering race will cause an error because the other characters don't have a model
	elif Input.is_action_just_pressed(player.controls.ui_deselect) and not player.character_select_pressed:
		back_button._pressed()
		ui_root._char_back_button_pressed()
	
	# UI next pressed
	if Input.is_action_just_pressed(player.controls.ui_next) and GameManager.validate_character_select():
		next_button._pressed()
		ui_root._character_next_button_pressed()
		

## Clamps cursor between 0 and num of character buttons 
func _keep_player_character_select_position_in_range(cursor_position : int) -> int:
	var new_position := cursor_position
	if cursor_position == len(character_buttons):
		new_position = 0
	elif cursor_position < 0:
		new_position = len(character_buttons) -1 
	return new_position

## Displays character in character view
func _show_character(select_position : int, id : int, player_added : bool = false) -> void:
	if !visible:
		return
	if player_added:
		character_buttons[select_position].unhide_indicator(id)
		_character_view_visibility_toggle()
		GameManager.validate_character_select()
		
	var model_instance := character_buttons[select_position].character_model.instantiate() as Model
	character_views[id].set_model_in_viewport(model_instance, id)
	character_views[id].current_model_packed_scene = character_buttons[select_position].character_model
	model_instance.current_state = model_instance.STATE.IN_CHARACTER_SELECT
	model_instance.selected = false

## Changes whether you can see character in character view
func _character_view_visibility_toggle() -> void:
	for views in character_views:
		if character_views.find(views) < GameManager.players_connected:
			views.visible = true
		else: 
			views.visible = false
