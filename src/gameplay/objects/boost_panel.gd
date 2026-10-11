extends Node3D

@export var boost_speed_divisor : float = 1.5
@export var boost_time_divisor : float = 1.5
		
func _on_area_3d_area_entered(area: Area3D) -> void:
	if area is SpinHurtBox:
		var spinHurtbox : SpinHurtBox = area
		spinHurtbox.apply_boost_panel_boost(3)
