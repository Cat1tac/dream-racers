class_name NavButton extends Button

@export_category("Offscreen Position")
@export var offscreen_vector_ratio: Vector2

var tween: Tween

func _ready() -> void:
	set_offscreen()

func enter() -> void:
	show()
	_reset_tween()
	offset_transform_enabled = true
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "offset_transform_position_ratio", Vector2.ZERO, 0.5)

func exit() -> void:
	_reset_tween()
	offset_transform_enabled = true
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "offset_transform_position_ratio", offscreen_vector_ratio, 0.5)
	await tween.finished
	offset_transform_scale = Vector2.ONE
	
func set_offscreen() -> void:
	hide()
	offset_transform_enabled = true
	offset_transform_position_ratio = offscreen_vector_ratio
	

func set_onscreen() -> void:
	show()
	offset_transform_enabled = false

func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()

func _pressed() -> void:
	exit()
