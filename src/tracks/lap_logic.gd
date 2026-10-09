class_name LapLogic extends Node

@export var track : Track
@onready var checkpoints: Node = $Checkpoints
@onready var starting_line: CollisionShape3D = $StartLine/CollisionShape3D

var check_list: Array[int]

# All print statements from LapLogic scripts are prefaced with "LapLogic: " for easy output reading

# Updates TrackInfo with relevant information (after getting checkpoint info)
# I've grown quite fond of this name
func talk_with_papa() -> void:
	await get_tree().create_timer(0.1).timeout # Lets checkpoints give info to this scripts before sending it to TrackInfo
	track.update(3, check_list) # (Number of laps, list of checkpoints)
	Events.on_checkpoints_list_filled.emit()

# recieves the instance id of each checkpoint in tree order (top to bottom)
func log_checkpoints(check_id : int) -> void:
	check_list.append(check_id)

# Tells LocalLapLogic to check for lap completion
func _on_start_line_area_entered(area: Area3D) -> void:
		if area is LocalLapLogic:
			var local_lap_logic : LocalLapLogic = area
			local_lap_logic.complete_lap()
			local_lap_logic.respawn_location = starting_line.global_position
			local_lap_logic.respawn_rotation = starting_line.global_rotation
			#print("LapLogic: Start Coords: " + str(starting_line.global_position))

# Debug function, prints instance id of each checkpoint in order
func print_checks() -> void:
	var _count := 0
	for id in check_list:
		_count += 1
		#print("LapLogic: check #" + str(_count) + " " + str(id))

func _ready() -> void:
	#print("LapLogic: loading checkpoints...")
	talk_with_papa()
	if track.willCountdown:
		await get_tree().create_timer(2).timeout
		await track.countdown(3, "race starting")
