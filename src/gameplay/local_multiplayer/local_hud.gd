class_name Local_Player_HUD extends CanvasLayer

@onready var lap_count_current: Label = %"Lap Count current"
@onready var lap_count_total: Label = %"Lap Count Total"
@onready var time_elapsed: Label = %Time
@export var speedometer : Speedometer
@onready var lap_count_h_box: HBoxContainer = $MarginContainer/LapCountHBox
var id : int

# tween properties
var tween: Tween
var tween_duration: float = 0.3
var lap_update_color: Color = Color(1.0, 0.34, 0.78, 1.0)

func _ready() -> void:
	speedometer.scale = Vector2(0.2, 0.2)
	Events.on_get_lap_count.connect(_update_lap_count)
	Events.on_get_time.connect(_update_timer)

func set_ids(player_id : int) -> void:
	id = player_id
	speedometer.id = player_id

# testing lap tween
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("keys_drift"):
		#_update_lap_tween()

func _update_lap_count(num : int, player_id) -> void:
	if id != player_id:
		return
		
	if num == 3:
		return
	
	_update_lap_tween()
	lap_count_current.text = str(num + 1)

func _update_timer(time : float) -> void:
	var minutes : int = int(time) / 60
	var seconds : int = int (time) % 60
	
	time_elapsed.text = "%02d:%02d" % [minutes, seconds]

#region tweens
func _update_lap_tween() -> void:
	lap_count_current.offset_transform_enabled = true
	
	# animate lap count 
	_reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	tween.tween_property(lap_count_h_box, "offset_transform_position_ratio", Vector2(0.5, -0.5), tween_duration)
	tween.tween_property(lap_count_h_box, "offset_transform_scale", Vector2(1.5, 1.5), tween_duration)
	tween.tween_property(lap_count_h_box, "modulate", lap_update_color, tween_duration * 2)
	
	await tween.finished
	
	# return to original state
	_reset_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK).set_parallel()
	tween.tween_property(lap_count_h_box, "offset_transform_position_ratio", Vector2.ZERO, tween_duration)
	tween.tween_property(lap_count_h_box, "offset_transform_scale", Vector2.ONE, tween_duration)
	tween.tween_property(lap_count_h_box, "modulate", Color("White"), tween_duration)
	
func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
#endregion
