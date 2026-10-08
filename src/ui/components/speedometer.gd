class_name Speedometer extends Control

@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var speed_label: Label = %SpeedLabel
## delays the pop in of speedometer
@export_range(0.0, 2.0, 0.1) var enter_time_delay: float 

var id : int

var tween: Tween

func _init() -> void:
	_set_offscreen()

func _ready() -> void:
	Events.on_get_speed.connect(_update_speed_label)
	
	await get_tree().create_timer(enter_time_delay).timeout
	_init_pop_in()

# for testing exit tween
#func _process(delta: float) -> void:
	#if Input.is_key_pressed(KEY_T):
		#_finish_exit_out()

func _update_speed_label(speed: float, _drift: float, player_id : int) -> void:
	## rounds and lerps [code]speed[/code] to reduce flickering when between two close int values
	if player_id == id:
		var display_speed: int = roundi(lerpf(speed, 1.0, 0.01))
		speed_label.text = str(display_speed)

func _set_offscreen() -> void:
	offset_transform_enabled = true
	offset_transform_position_ratio = Vector2(0, 1.2)

func _init_pop_in() -> void:
	_reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "offset_transform_position_ratio", Vector2(0,0), 1.0)

func _finish_exit_out() -> void:
	_reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "offset_transform_position_ratio", Vector2(0,1.2), 1.0)

func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
