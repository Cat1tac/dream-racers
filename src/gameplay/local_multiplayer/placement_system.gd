class_name PlacementSystem extends Node

var placementArray: Array[Dictionary]

func _ready() -> void:
	var number_of_players : int = GameManager.player_list.size()
	for player in GameManager.player_list:
		placementArray.append({player.id : player.score})
	Events.players_finished_race.connect(_sort_by_time)

func _sort_by_time() -> void:
	for player in GameManager.player_list:
		placementArray[player.id] = {player.id : player.completion_time}
	placementArray.sort_custom(_time_sort)

func _time_sort(player_a : PlayerDefinition, player_b : PlayerDefinition):
	if player_a.completion_time > player_b.completion_time:
		return false
	return true
