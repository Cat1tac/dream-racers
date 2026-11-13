class_name Checkpoint extends Area3D

@onready var lap_logic: LapLogic = $"../.."

@export var is_key_checkpoint : bool 
@export var is_split_path : bool

var box_id: Array
var cpu_position: Vector3

## send lap_logic.gd each instance ID
func _ready() -> void:
	if is_split_path:
		box_id = [$Zone, $Zone2]
		$Zone.is_key_checkpoint = is_key_checkpoint
		$Zone2.is_key_checkpoint = is_key_checkpoint
	else:
		box_id = [$Zone]
		$Zone.is_key_checkpoint = is_key_checkpoint
	cpu_position = $Zone.global_position
