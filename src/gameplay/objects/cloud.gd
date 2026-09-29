extends Node3D

@export var bounce_height : float = 15
@export var charge_need_for_super_bounce : float = 4

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area is SpinHurtBox:
		var hurt_box : SpinHurtBox = area
		hurt_box.call_vertical_bounce(bounce_height)
		if hurt_box.kart_sphere.tricked:
			hurt_box.call_slowdown(-0.3) #if negative will turn slowdown into boost
		hurt_box.reset_trick()
		


func _on_area_3d_area_exited(area: Area3D) -> void:
	await get_tree().create_timer(0.2).timeout
	if area is SpinHurtBox:
		var hurt_box : SpinHurtBox = area
		if hurt_box.kart_sphere.charge_level >= charge_need_for_super_bounce:
			hurt_box.call_vertical_bounce(15)
		
