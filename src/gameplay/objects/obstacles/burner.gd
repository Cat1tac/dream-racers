extends Node3D

@onready var timer: Timer = $Timer
@onready var hitbox: CollisionShape3D = $FlameBox/CollisionShape3D
@onready var embers: GPUParticles3D = $burner/GPUParticles3D
@onready var flame: MeshInstance3D = $burner/Flame
@onready var light: SpotLight3D = $SpotLight3D

@export var slowdown : float = 0.8
enum STATES {
	STARTING,
	ON,
	OFF
}

var currentState : STATES = STATES.OFF
var just_entered_state : bool
var elongate_change : float
var fill_change : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.on_countdown_finished.connect(on_race_start)

func _process(delta : float) -> void:
	if timer.wait_time - timer.time_left <= timer.wait_time * 0.3:
		currentState = STATES.STARTING
	elif timer.wait_time - timer.time_left <= timer.wait_time * 0.7:
		currentState = STATES.ON
	elif timer.wait_time - timer.time_left <= timer.wait_time * 1:
		currentState = STATES.OFF
		 
	match currentState:
		STATES.STARTING:
			elongate_change = lerp(elongate_change, 0.3, 1 - pow(0.01, delta))
			fill_change = 1
			embers.emitting = true
			hitbox.disabled = true
			light.show()
			light.spot_range = 20
		STATES.ON:
			elongate_change = lerp(elongate_change, 1.0, 1 - pow(0.01, delta))
			fill_change = 1
			embers.emitting = true
			hitbox.disabled = false
			light.show()
			light.spot_range = 35
		STATES.OFF:
			elongate_change = lerp(elongate_change, 0.0, 1 - pow(0.03, delta))
			fill_change = lerp(fill_change, 0.0, 1 - pow(0.04, delta))
			embers.emitting = false
			hitbox.disabled = true
			light.hide()
			
	flame.material_override.set_shader_parameter("elongate", elongate_change)
	flame.material_override.set_shader_parameter("fill", fill_change)

func on_race_start() -> void:
	timer.start()

func _on_area_entered(area: Area3D) -> void:
	if area is SpinHurtBox:
		area.kart_sphere.apply_slowdown_force(slowdown)
		
