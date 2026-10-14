class_name KartParticlesManager extends Node3D

@export var particles : Array[GPUParticles3D]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_particles(stage : int) -> void:
	_disable_all_effects()
	_enable_effect(stage)

func _disable_all_effects() -> void:
	for effect in particles:
		effect.emitting = false
		effect.visible = false

func _enable_effect(stage : int) -> void:
	if stage >= 0:
		particles[stage].restart()
		particles[stage].interp_to_end = 0
		particles[stage].emitting = true
		particles[stage].visible = true

func fade(stage : int, time : float, max_time : float) -> void:
	particles[stage].interp_to_end = remap(time, max_time, 0, 0, 1)
