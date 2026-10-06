## handles how many players, characters of each player, track selected and
## any other logic that "sets up" the game
extends Node

signal all_players_selected_character

var main_game_scene: PackedScene = preload("res://src/core/main_game/main_game.tscn")

## stores all predefined PlayerControls resources
var playerControls : Dictionary[PlayerControls, int] 

## updates whenever a player is added
var players_connected := 0

## an array containing all players and their attributes (id, character, controls, etc)
var player_list: Array[PlayerDefinition] = []

#region enums
enum SelectedCharacter {
	NONE,
	SERAPHIM,
	NYX,
	MUFFIN,
}

enum SelectedTrack {
	NONE, ## No track is selected
	TREE, ## Yggdrasil Tree
	SHIP, ## Baa Baa Battleship
}
#endregion

## updates when track is selected from track select
var current_track: SelectedTrack = SelectedTrack.NONE


func _init() -> void:
	load_player_controls()

## Will be used to read player input and see if another player has joined the game
func _input(event: InputEvent) -> void:
	for controls in  playerControls:
		if event.is_action(controls.ui_select) and playerControls[controls] == 0:
			playerControls[controls] = 1
			add_player(controls)
		
#region game setup
func load_player_controls() -> void:
	var p1_controls : PlayerControls = preload(ScenePaths.CONTROLS.p1)
	playerControls[p1_controls] = 0
	
	var p2_controls : PlayerControls = preload(ScenePaths.CONTROLS.p2)
	playerControls[p2_controls] = 0

func add_player(controls : PlayerControls) -> void:
	players_connected += 1
	print(controls)
	var new_player : PlayerDefinition = preload(ScenePaths.PLAYER.player_definition).duplicate()
	new_player.id = players_connected - 1
	new_player.controls = controls
	new_player.selected_character = SelectedCharacter.NONE
	new_player.character_select_position = 0
	new_player.character_select_pressed = false
	player_list.append(new_player)
	Events.on_player_added.emit(new_player.character_select_position, new_player.id, true)

func remove_player() -> void:
	players_connected -= 1
	player_list.pop_back()

## sets character based on MyCharacter enum passed
func set_character(character: SelectedCharacter) -> void:
	player_list[0].selected_character = character

func set_track(given_track: SelectedTrack) -> void:
	current_track = given_track
	print(SelectedTrack.keys()[given_track] + " selected!")

## check if all players have selected a character
func validate_character_select() -> bool:
	for player in player_list:
		if player.selected_character == SelectedCharacter.NONE:
			return false
		
	all_players_selected_character.emit()
	return true
#endregion

func load_into_main_game() -> void:
	get_tree().change_scene_to_packed(main_game_scene)
