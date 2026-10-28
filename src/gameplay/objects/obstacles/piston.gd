extends Node3D

@onready var timer: Timer = $Timer
@onready var slam_area: Area3D = $SlamBox

@onready var slam_box: CollisionShape3D = $SlamBox/CollisionShape3D
@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D

@export var timing_offset : float = 0

var tween : Tween
var wind_up_time : float = 1.0
var slam_time : float = 0.2
var rise_time : float = 2.0

var start_position : Vector3

enum STAGES {
	WIND_UP,
	SLAM,
	RISE,
}

var current_stage : STAGES = STAGES.RISE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.one_shot = true
	start_position = global_position
	await get_tree().create_timer(timing_offset).timeout 
	move_piston()
	update_timer()

# Progresses Piston Stage and calls relevant functions
func _on_timer_timeout() -> void:
	increase_stage()
	move_piston()
	update_timer()
	
# Disable/Enable piston hitbox depending on stage
func move_piston() -> void:
	match current_stage:
		STAGES.WIND_UP:
			_reset_tween()
			tween.tween_property(self, "global_position", Vector3(start_position.x, start_position.y + 10, start_position.z), wind_up_time)
			slam_box.disabled = true
		STAGES.SLAM:
			_reset_tween()
			tween.tween_property(self, "global_position", start_position, slam_time)
			slam_box.disabled = false
		STAGES.RISE:
			_reset_tween()
			tween.tween_property(self, "global_position", Vector3(start_position.x, start_position.y + 7, start_position.z), rise_time)
			slam_box.disabled = true
			
func increase_stage() -> void:
	if current_stage == STAGES.WIND_UP:
		current_stage = STAGES.SLAM
	elif current_stage == STAGES.SLAM:
		current_stage = STAGES.RISE
	elif current_stage == STAGES.RISE:
		current_stage = STAGES.WIND_UP

# Changes timing of stages
func update_timer() -> void:
	match current_stage:
		STAGES.WIND_UP:
			timer.start(wind_up_time)
		STAGES.SLAM:
			timer.start(slam_time + 0.4)
		STAGES.RISE:
			timer.start(rise_time + 1)

func _on_slam_box_area_entered(area: Area3D) -> void:
	if area is SpinHurtBox:
		var kart : Kart_Sphere = area.kart_sphere
		print("kart_y: " , area.global_position.y, "\nslam box y: ", slam_box.global_position.y)
		if global_position != start_position:
			print("yar")
			kart.apply_slowdown_force(1)
		else:
			shape_cast_3d.force_shapecast_update()
			if shape_cast_3d.is_colliding():
				for i in shape_cast_3d.get_collision_count():
				# make it so that if the player is to one side of the opponent, their collision box will not use a collision point that is on the opposite side. Instead it will default to 1 of the opposite sign
					var collision_point = to_local(shape_cast_3d.get_collision_point(i)).normalized()
					print("area: " + str(to_local(area.global_position)))
					#collision_point.x = 1 * signf(to_local(area.global_position).x)
					kart.apply_bounce_force(10, Vector3(collision_point.x, 0, collision_point.z))
			
func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
