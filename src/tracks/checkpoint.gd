class_name Checkpoint extends Area3D

@onready var lap_logic: LapLogic = $"../.."

@export var is_key_checkpoint : bool 
@export var is_split_path : bool

var box_id: Array

## send lap_logic.gd each instance ID
func _ready() -> void:
	if is_split_path:
		box_id = [$Zone, $Zone2]
		$Zone.is_key_checkpoint = is_key_checkpoint
		$Zone2.is_key_checkpoint = is_key_checkpoint
	else:
		box_id = [$Zone]
		$Zone.is_key_checkpoint = is_key_checkpoint
	# sets given rotation to an accurate radian value for the CPU racer
	# since for some reason the global rotations are 90 degrees off
	var temp_rotation : float = global_rotation.y + 1.57
	if temp_rotation > 3.14:
		temp_rotation = temp_rotation - 6.28
