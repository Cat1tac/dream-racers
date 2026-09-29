class_name CameraPivot extends Node3D

var tween : Tween

func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	
func tween_new_basis(new_basis : Basis) -> void:
	_reset_tween()
	tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_method(_set_new_basis, global_basis, new_basis, 1.5)
	
func _set_new_basis(current_basis : Basis) -> void:
	global_basis = current_basis
