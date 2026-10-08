class_name NavButton extends Button
enum NavButtonType {
	BACK,
	NEXT,
}
@export var type: NavButtonType
@export_category("Offscreen Position")
@export var offscreen_vector: Vector2

var tween: Tween

func _ready() -> void:
	set_offscreen()

func enter() -> void:
	_reset_tween()
	offset_transform_enabled = true
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "offset_transform_position_ratio", Vector2.ZERO, 0.5)

func exit() -> void:
	_reset_tween()
	offset_transform_enabled = true
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "offset_transform_position_ratio", offscreen_vector, 0.5)
	
func set_offscreen() -> void:
	offset_transform_enabled = true
	offset_transform_position_ratio = offscreen_vector

func set_onscreen() -> void:
	offset_transform_enabled = false

func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()

func _pressed() -> void:
	exit()
