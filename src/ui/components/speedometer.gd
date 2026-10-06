extends Control

@onready var speed_label: Label = $BaseMeter/SpeedLabel

var tween: Tween

func _init() -> void:
	_init_pop_in()

func _ready() -> void:
	Events.on_get_speed.connect(_update_speed_label)

# for testing exit tween
#func _process(delta: float) -> void:
	#if Input.is_key_pressed(KEY_T):
		#_finish_exit_out()

func _update_speed_label(speed: float, _drift: float) -> void:
	## rounds and lerps [code]speed[/code] to reduce flickering when between two close int values
	var display_speed: int = roundi(lerpf(speed, 1.0, 0.01))
	speed_label.text = str(display_speed)

func _init_pop_in() -> void:
	_reset_tween()
	offset_transform_enabled = true
	offset_transform_position_ratio = Vector2(0, 1.2)
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
