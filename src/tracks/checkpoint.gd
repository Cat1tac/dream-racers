extends Area3D

@onready var lap_logic: LapLogic = $"../.."
@onready var res_point: Marker3D = $RespawnPoint

# All print statements from LapLogic scripts are prefaced with "LapLogic: " for easy output reading

func _ready() -> void:
	#send lap_logic.gd each instance ID
	lap_logic.log_checkpoints(get_instance_id())
	
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
		if !area.playerControlled:
			print("CLANKER ALERT")
