extends Node

@onready var button_v_box: VBoxContainer = $InfoMainScreen/ButtonMargin/ButtonVBox

var tween : Tween

func _ready() -> void:
	await GameManager.load_finished
	_reset_tween()
	
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	
	for button : Control in button_v_box.get_children():
		button.offset_transform_enabled = true
		button.offset_transform_position_ratio = Vector2(-2, 0)
		tween.tween_property(button, "offset_transform_position_ratio", Vector2.ZERO, 0.5).set_delay(button.get_index() * 0.1)
	
func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
