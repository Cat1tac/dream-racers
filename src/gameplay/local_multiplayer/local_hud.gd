class_name Local_Player_HUD extends CanvasLayer

@export var speedometer : Speedometer
var id : int

func _ready() -> void:
	speedometer.scale = Vector2(0.2, 0.2)

func set_ids(player_id : int) -> void:
	id = player_id
	speedometer.id = player_id
	
