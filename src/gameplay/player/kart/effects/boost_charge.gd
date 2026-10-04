class_name KartParticlesManager extends Node3D

@export var drift_particles : Array[GPUParticles3D]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_drifting_stage(stage : int) -> void:
	_disable_all_drift_effects()
	_enable_drift_effect(stage)

func _disable_all_drift_effects() -> void:
	for effect in drift_particles:
		effect.emitting = false
		effect.visible = false

func _enable_drift_effect(stage : int) -> void:
	if stage >= 0:
		#print()
		drift_particles[stage].restart()
		drift_particles[stage].emitting = true
		drift_particles[stage].visible = true
