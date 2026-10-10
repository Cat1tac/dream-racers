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
	Events.on_get_stored_charge.connect(_updated_stored_charge_meter)
	await get_tree().create_timer(enter_time_delay).timeout
	_init_pop_in()

# for testing exit tween
#func _process(delta: float) -> void:
	#if Input.is_key_pressed(KEY_T):
		#_finish_exit_out()

func _updated_stored_charge_meter(store_lvl : int, in_between : int, player_id : int) -> void:
	if player_id != id:
		return
	if store_lvl == 0:
		texture_progress_bar.value = 0
	elif store_lvl == 3:
		texture_progress_bar.value = 1.4
	elif store_lvl == 4 and in_between == 1:
		texture_progress_bar.value = 3.2
	elif store_lvl == 4 and in_between == 2:
		texture_progress_bar.value = 4.9
	elif store_lvl == 5 and in_between == 3:
		texture_progress_bar.value = 6.9
	elif store_lvl == 5 and in_between == 4:
		texture_progress_bar.value = 8.0
	elif store_lvl == 5 and in_between == 5:
		texture_progress_bar.value = 9.0
	elif store_lvl == 6:
		texture_progress_bar.value = 10

func _update_speed_label(speed: float, _drift: float, player_id : int) -> void:
	## rounds and lerps [code]speed[/code] to reduce flickering when between two close int values
	if player_id == id:
		var display_speed: int = roundi(lerpf(speed * 2.23694, 1.0, 0.01))
		
		speed_label.text = str(abs(display_speed)) #converts to mph

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
