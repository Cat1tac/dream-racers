extends Area3D

@onready var lap_logic: LapLogic = $"../.."
@onready var res_point: Marker3D = $RespawnPoint

# All print statements from LapLogic scripts are prefaced with "LapLogic: " for easy output reading

## send lap_logic.gd each instance ID
func _ready() -> void:
	
	# sets given rotation to an accurate radian value for the CPU racer
	# since for some reason the global rotations are 90 degrees off
	var temp_rotation = global_rotation.y + 1.57
	if temp_rotation > 3.14:
		temp_rotation = temp_rotation - 6.28
	lap_logic.log_checkpoints(get_instance_id(), temp_rotation)
	
	#send lap_logic.gd each instance position & rotation

## Communicates instance information when checkpoint is crossed
func _on_area_entered(area: Area3D) -> void:
	if area is LocalLapLogic:
		var local_lap_logic : LocalLapLogic = area
		local_lap_logic.add_checkpoint(get_instance_id())
		local_lap_logic.respawn_location = res_point.global_position
		local_lap_logic.respawn_rotation = res_point.global_rotation
		#print("CheckLapLogic: Respawn Rotation is " + str(local_lap_logic.respawn_rotation))
		#print("CheckLapLogic: Respawn Rotation should be " + str(self.global_rotation_degrees))
