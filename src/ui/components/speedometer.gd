extends Control

@onready var speed_label: Label = $BaseMeter/SpeedLabel

var pop_in: Tween = create_tween().bind_node(self)

func _init() -> void:
	pop_in.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	pop_in.tween_property(self, "offset_transform_position_ratio", Vector2(0,0), 1.0)

func _ready() -> void:
	Events.on_get_speed.connect(_update_speed_label)

func _update_speed_label(speed: float, _drift: float) -> void:
	speed_label.text = str(roundi(speed))
	

func reset_tween(tween: Tween) -> void:
	if tween:
		tween.kill()
