class_name LapLogic extends Node

@export var track : Track
@onready var checkpoints: Node = $Checkpoints
@onready var cpu_path: Node = $CPUPath
@onready var respawn_point: Marker3D = $"StartLine/Respawn Point"
@export var lap_count : int = 3
@onready var start_line: Area3D = $StartLine

func get_checkpoints() -> Array[Checkpoint]:
	var temp_checkpoint_array : Array[Checkpoint]
	for child : Checkpoint in checkpoints.get_children():
		temp_checkpoint_array.append(child)
	return temp_checkpoint_array

func get_cpu_path_positions() -> Array[Vector3]:
	var temp_position_array : Array[Vector3]
	for child : CPUArea in cpu_path.get_children():
		temp_position_array.append(child.position)
	return temp_position_array

func get_cpu_checks() -> Array[CPUArea]:
	var temp_check_array: Array[CPUArea]
	for child : CPUArea in cpu_path.get_children():
		temp_check_array.append(child)
	return temp_check_array

## Tells LocalLapLogic to check for lap completion
func _on_start_line_area_entered(area: Area3D) -> void:
	if area is LocalLapLogic:
		var local_lap_logic : LocalLapLogic = area
		local_lap_logic.complete_lap()
		local_lap_logic.respawn_location = respawn_point.global_position
		local_lap_logic.respawn_rotation = respawn_point.global_rotation

func _ready() -> void:
	Events.get_start_line_position.emit(start_line.global_position)
	if track.willCountdown:
		await get_tree().create_timer(2).timeout
		track.countdown(3)
