extends Node

@onready var checkpoints: Node = $Checkpoints

var check_list: Array[int]

# All print statements from LapLogic scripts are prefaced with "LapLogic: " for easy output reading

# recieves the instance id of each checkpoint in tree order (top to bottom)
func log_checkpoints(check_id) -> void:
	check_list.append(check_id)

# Tells LocalLapLogic to check for lap completion
# also the if statement after complete_lap() is a bandage fix for communicating with specific player instance at "start" of the race
func _on_start_line_area_entered(area: Area3D) -> void:
		if area is LocalLapLogic:
			area.complete_lap()
			area.get_check_order(check_list)

# Debug function, prints instance id of each checkpoint in order
func print_checks() -> void:
	var count: int
	for id in check_list:
		count += 1
		print("LapLogic: check #" + str(count) + " " + str(id))
