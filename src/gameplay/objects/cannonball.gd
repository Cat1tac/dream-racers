extends StaticBody3D

func _on_lifespan_timeout() -> void:
	queue_free()

# Do not know how the call_knockback function works so calling bounce instead temporarily
func _on_area_3d_area_entered(area: Area3D) -> void:
	if area is SpinHurtBox:
		# area.call_knockback(5.0)
		area.call_bounce(10.0)

func _on_tree_entered() -> void:
	pass # Replace with function body.
