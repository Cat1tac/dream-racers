class_name CPUArea extends Area3D

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _on_area_entered(area: Area3D) -> void:
	if area is LocalLapLogic:
		area.add_cpu_zone(self)
