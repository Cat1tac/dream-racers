## handles how many players, characters of each player, track selected and
## any other logic that "sets up" the game
extends Node

## updates whenever a player is added
var players_connected = 0

#region enums
enum MyCharacter {
	NONE,
	SERAPHIM,
	NYX,
	MUFFIN,
}

enum Track {
	NONE,
	TREE,
	SHIP,
}
#endregion

## updates when track is selected from track select
var current_track: Track = Track.NONE

## array containing all players
var player_list: Array = []

func _init() -> void:
	add_player()

func add_player():
	players_connected += 1
	player_list.append(
		{"PlayerNumber": players_connected, "SelectedCharacter": MyCharacter.NONE}
		)

func remove_player():
	players_connected -= 1
	player_list.pop_back()

## sets character based on MyCharacter enum passed
func set_character(char: MyCharacter):
	player_list[0]["SelectedCharacter"] = char


func set_track(given_track: Track):
	current_track = given_track
	print(Track.keys()[given_track] + " selected!")
