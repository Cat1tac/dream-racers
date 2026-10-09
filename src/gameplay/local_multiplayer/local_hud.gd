class_name Local_Player_HUD extends CanvasLayer

@onready var lap_count_current: Label = %"Lap Count current"
@onready var lap_count_total: Label = %"Lap Count Total"
@onready var time_elapsed: Label = %Time
@export var speedometer : Speedometer
var id : int

func _ready() -> void:
	speedometer.scale = Vector2(0.2, 0.2)
	Events.on_get_lap_count.connect(_update_lap_count)
	Events.on_get_time.connect(_update_timer)

func set_ids(player_id : int) -> void:
	id = player_id
	speedometer.id = player_id

func _update_lap_count(num : int) -> void:
	lap_count_current.text = str(num)

func _update_timer(time : float) -> void:
	var minutes : int = int(time) / 60
	var seconds : int = int (time) % 60
	
	time_elapsed.text = "%02d:%02d" % [minutes, seconds]
