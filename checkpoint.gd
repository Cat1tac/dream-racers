extends Area3D

@onready var LapLogic: Node = $"../.."

# All print statements from LapLogic scripts are prefaced with "LapLogic: " for easy output reading

func _ready() -> void:
	#send lap_logic.gd each instance ID
	LapLogic.log_checkpoints(get_instance_id())


# Does funny thing when a checkpoint is crossed
func _on_area_entered(area: Area3D) -> void:
	if area is LocalLapLogic:
		area.add_checkpoint(get_instance_id())
