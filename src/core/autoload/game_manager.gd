## handles how many players, characters of each player, track selected and
## any other logic that "sets up" the game
extends Node

signal all_players_selected_character

var main_game_scene: PackedScene = preload("res://src/core/main_game/main_game.tscn")
## updates whenever a player is added
var players_connected := 0

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

## an array containing all players
var player_list: Array[Dictionary] = []

func _init() -> void:
	add_player()

#region game setup
func add_player() -> void:
	players_connected += 1
	player_list.append(
		{"PlayerNumber": players_connected, "SelectedCharacter": SelectedCharacter.NONE}
		)

func remove_player() -> void:
	players_connected -= 1
	player_list.pop_back()

## sets character based on MyCharacter enum passed
func set_character(character: SelectedCharacter) -> void:
	player_list[0]["SelectedCharacter"] = character

func set_track(given_track: SelectedTrack) -> void:
	current_track = given_track
	print(SelectedTrack.keys()[given_track] + " selected!")

## check if all players have selected a character
func validate_character_select() -> bool:
	for player in player_list:
		if player["SelectedCharacter"] == SelectedCharacter.NONE:
			return false
		
	all_players_selected_character.emit()
	return true
#endregion

func load_into_main_game() -> void:
	get_tree().change_scene_to_packed(main_game_scene)
