class_name Trail_Object extends Node3D

@onready var random_cloud: Node3D = %Random_Cloud
@onready var timer: Timer = $Timer
var spawn_position : Vector3
var rotation_speed : Vector3
var scale_factor : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = spawn_position
	random_cloud.global_rotation = Vector3(randf_range(0, TAU), randf_range(0, TAU), randf_range(0, TAU))
	rotation_speed = Vector3(randf_range(-0.5, 0.5), randf_range(-0.5, 0.5), randf_range(-0.5, 0.5))
	scale_factor = random_cloud.scale.x
	
	
func _process(delta: float) -> void:
	var x : float = lerp_angle(random_cloud.global_rotation.x, random_cloud.global_rotation.x + rotation_speed.x, delta)
	var y : float = lerp_angle(random_cloud.global_rotation.y, random_cloud.global_rotation.y + rotation_speed.y, delta)
	var z : float = lerp_angle(random_cloud.global_rotation.z, random_cloud.global_rotation.z + rotation_speed.z, delta)
	
	random_cloud.global_rotation = Vector3(x,y,z)
	
	random_cloud.scale = Vector3.ONE * lerp(random_cloud.scale.x, random_cloud.scale.x - (scale_factor / timer.wait_time), delta)
	
	
func _on_timer_timeout() -> void:
	queue_free()
