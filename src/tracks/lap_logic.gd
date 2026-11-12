class_name LapLogic extends Node

@export var track : Track
@onready var checkpoints: Node = $Checkpoints
@onready var respawn_point: Marker3D = $"StartLine/Respawn Point"
@export var lap_count : int = 3

# All print statements from LapLogic scripts are prefaced with "LapLogic: " for easy output reading

func get_checkpoints() -> Array:
	var temp_checkpoint_array : Array
	for child : Checkpoint in checkpoints.get_children():
		temp_checkpoint_array.append(child.box_id)
	return temp_checkpoint_array
		

## Tells LocalLapLogic to check for lap completion
func _on_start_line_area_entered(area: Area3D) -> void:
	if area is LocalLapLogic:
		var local_lap_logic : LocalLapLogic = area
		local_lap_logic.complete_lap()
		local_lap_logic.respawn_location = respawn_point.global_position
		local_lap_logic.respawn_rotation = respawn_point.global_rotation

func _ready() -> void:
	
	if track.willCountdown:
		await get_tree().create_timer(2).timeout
		track.countdown(3)
