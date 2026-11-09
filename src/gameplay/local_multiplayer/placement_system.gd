class_name PlacementSystem extends Node

var player_scores : Dictionary[int, float]
var scores_array: Array[float]

func _ready() -> void:
	var number_of_players : int = GameManager.player_list.size()

	#Events.players_finished_race.connect(_sort_by_time)

## for dynamic placement
func _process(_delta: float) -> void:
	for player in GameManager.player_list:
		player_scores[player.id] = player.score
		scores_array.append(player.score)
	# sorts in descending order, greater score -> higher placement
	scores_array.sort()
	scores_array.reverse()
	
	# get placement via scores and emit with id and index
	for player in GameManager.player_list:
		var score : float = player_scores[player.id]
		var placement_index : int = scores_array.find(score)
		Events.on_placement_update.emit(player.id, placement_index)
	scores_array.clear()

#func _sort_by_time() -> void:
	#for player in GameManager.player_list:
		#placementArray[player.id] = {player.id : player.completion_time}
	#placementArray.sort_custom(_time_sort)

func _time_sort(player_a : PlayerDefinition, player_b : PlayerDefinition):
	if player_a.completion_time > player_b.completion_time:
		return false
	return true
