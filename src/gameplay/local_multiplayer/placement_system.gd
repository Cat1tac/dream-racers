class_name PlacementSystem extends Node

var player_scores : Dictionary[int, float]
var scores_array: Array[float]

func _ready() -> void:
	var number_of_players : int = GameManager.player_list.size()

	Events.on_race_over.connect(_sort_by_time)

## for dynamic placement
func _process(_delta: float) -> void:
	if not GameManager.is_in_match:
		return
	
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

## on race completion, players will be sorted by completion time
func _sort_by_time() -> void:
	scores_array.clear()
	
	for player in GameManager.player_list:
		player_scores[player.id] = player.completion_time
		scores_array.append(player.completion_time)
	
	scores_array.sort()
	
	for player in GameManager.player_list:
		var time : float = player_scores[player.id]
		var placement_index : int = scores_array.find(time)
		Events.on_final_placement.emit(player.id, placement_index)
		print("player_id: " + str(player.id) + "at placement_index: " + str(placement_index))
	
	scores_array.clear()
