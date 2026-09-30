extends Node

@onready var checkpoints: Node = $Checkpoints

var check_list: Array[int]

# All print statements from LapLogic scripts are prefaced with "LapLogic: " for easy output reading

#TEMP NAME I'LL CHANGE IT BEFORE NEXT MEETING
func talk_with_papa() -> void:
	await get_tree().create_timer(0.1).timeout
	print("LapLogic: hi")
	TrackInfo.update(3, check_list)

# recieves the instance id of each checkpoint in tree order (top to bottom)
func log_checkpoints(check_id) -> void:
	check_list.append(check_id)

# Tells LocalLapLogic to check for lap completion
# also the if statement after complete_lap() is a bandage fix for communicating with specific player instance at "start" of the race
func _on_start_line_area_entered(area: Area3D) -> void:
		if area is LocalLapLogic:
			area.complete_lap()

# Debug function, prints instance id of each checkpoint in order
func print_checks() -> void:
	var count: int
	for id in check_list:
		count += 1
		print("LapLogic: check #" + str(count) + " " + str(id))

func _ready() -> void:
	print("LapLogic: loading checkpoints. please wait 2 seconds")
	talk_with_papa()
	await get_tree().create_timer(2).timeout
	await TrackInfo.countdown(3, "race starting")
