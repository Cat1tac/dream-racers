class_name CannonExplosion extends Node3D
@onready var warning_decal: Decal = $Decal
@onready var visuals: Node3D = $Visuals
@onready var timer: Timer = $Timer
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
@onready var explosion_mesh: MeshInstance3D = $Visuals/MeshInstance3D
@onready var area_3d: Area3D = $Area3D
@onready var embers: GPUParticles3D = $Visuals/GPUParticles3D
@onready var light: OmniLight3D = $OmniLight3D

@export var full_scale : float = 40

enum STATES {
	STARTING,
	ON,
	OFF
}
var activated : bool
var currentState : STATES = STATES.OFF
var fill_change : float
var _time : float

var decal_y : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explosion_mesh.material_override = explosion_mesh.material_override.duplicate_deep()
	decal_y = warning_decal.global_position.y
	warning_decal.size = Vector3(full_scale, 1, full_scale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer.wait_time - timer.time_left <= timer.wait_time * 0.5:
		currentState = STATES.STARTING
	elif timer.wait_time - timer.time_left <= timer.wait_time * 0.95:
		currentState = STATES.ON
	elif timer.wait_time - timer.time_left <= timer.wait_time * 1:
		currentState = STATES.OFF
		
	match currentState:
		STATES.STARTING:
			warning_decal.show()
			warning_decal.global_position.y = remap(sin(_time * TAU), -1.0, 1.0, decal_y, decal_y - 1)
			_time += delta
			
			visuals.hide()
			fill_change = 1
			visuals.scale = Vector3.ONE
			collision_shape_3d.disabled = true
			light.hide()
		STATES.ON:
			visuals.show()
			warning_decal.hide()
			visuals.scale = lerp(visuals.scale, Vector3.ONE * full_scale, 1 - pow(0.01, delta))
			fill_change = 1
			collision_shape_3d.disabled = false
			embers.emitting = true
			light.show()
		STATES.OFF:
			warning_decal.hide()
			warning_decal.global_position.y = decal_y
			collision_shape_3d.disabled = true
			embers.emitting = false
			fill_change = lerp(fill_change, 0.0, 1 - pow(0.02, delta))
			if fill_change <= 0.001:
				visuals.hide()
				activated = false
			light.hide()
	area_3d.scale = visuals.scale
	explosion_mesh.material_override.set_shader_parameter("fill", fill_change)

func activate_explosion_timer(time : float = 4.0) -> void:
	timer.start(time)
	activated = true


func _on_area_3d_area_entered(area: Area3D) -> void:
	print("hit")
	if area is SpinHurtBox:
		var kart = area.kart_sphere
		kart.apply_slowdown_force(0.8)
		kart.current_boost_level = kart.BOOST_LEVEL.ZERO
