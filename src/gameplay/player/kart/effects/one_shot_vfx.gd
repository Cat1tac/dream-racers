class_name OneShotVFX extends Node3D

var particles : Array[GPUParticles3D]

func _ready() -> void:
	for child in get_children():
		if child is GPUParticles3D:
			particles.append(child)

func _process(_delta: float) -> void:
	for effect in particles:
		await effect.finished
		particles.erase(effect)
		effect.queue_free()
	if get_child_count() == 0:
		queue_free()

func play_vfx(point : Vector3) -> void:
	print("we up")
	global_position = point
	for effect in particles:
		effect.emitting = true
