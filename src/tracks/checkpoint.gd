class_name Checkpoint extends Area3D

@onready var lap_logic: LapLogic = $"../.."
@onready var res_point: Marker3D = $RespawnPoint

@export var is_key_checkpoint : bool 
@export var is_split_path : bool

#var box_id: Array[Area3D]
#
### send lap_logic.gd each instance ID
#func _ready() -> void:
	#if is_split_path:
		#box_id = [$Zone, $Zone2]
		#$Zone.is_key_checkpoint = is_key_checkpoint
		#$Zone2.is_key_checkpoint = is_key_checkpoint
	#else:
		#box_id = [$Zone]
		#$Zone.is_key_checkpoint = is_key_checkpoint

## Communicates instance information when checkpoint is crossed
func _on_area_entered(area: Area3D) -> void:
		if area is LocalLapLogic:
			var local_lap_logic : LocalLapLogic = area
			local_lap_logic.add_checkpoint(self)
			local_lap_logic.update_respawn_point(self)
