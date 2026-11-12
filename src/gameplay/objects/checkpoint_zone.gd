class_name CheckpointZone extends Area3D

@onready var res_point = $RespawnPoint

var is_key_checkpoint : bool 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func grab_zone_info():
	return self

## Communicates instance information when checkpoint is crossed
func _on_area_entered(area: Area3D) -> void:
		if area is LocalLapLogic:
			var local_lap_logic : LocalLapLogic = area
			local_lap_logic.add_checkpoint(self)
			local_lap_logic.update_respawn_point(self)
