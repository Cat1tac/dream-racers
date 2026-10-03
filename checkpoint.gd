extends Area3D

@onready var LapLogic: Node = $"../.."
@onready var res_point: Node = $RespawnPoint

# All print statements from LapLogic scripts are prefaced with "LapLogic: " for easy output reading

func _ready() -> void:
	#send lap_logic.gd each instance ID
	LapLogic.log_checkpoints(get_instance_id())

# Communicates instance information when checkpoint is crossed
func _on_area_entered(area: Area3D) -> void:
	if area is LocalLapLogic:
		area.add_checkpoint(get_instance_id())
		area.respawn_location = self.global_position
		area.respawn_rotation = self.global_rotation
		print("CheckLapLogic: Respawn Rotation is " + str(area.respawn_rotation))
		print("CheckLapLogic: Respawn Rotation should be " + str(self.global_rotation_degrees))
