class_name Kart extends CharacterBody3D
## Handles all movement and phsyics interaction dealing with the kart

@export var shapecasts : Array[ShapeCast3D]
@export var particlesManager : Array[KartParticlesManager]
@onready var kart_model: Node3D = $Kart_Model

#Inputs
var input_acceleration : float
var input_steering : float
var input_drift : bool

var drift_direction : float

#Stats
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s") var top_speed := 50.0 # Will be stat adjustable
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s") var reverse_top_speed := 20.0 
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s^2") var acceleration := 10.0 # Will be sta adjustable
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s^2") var boost_acceleration := 50.0
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s") var boost_top_speed : = 15.0
@export var break_resistance := 40.0
@export var ground_resistance := 0.55
@export var gravity_acceleration := Vector3(0, -98, 0) #how fast you fall

@export_group("Steering")
@export_custom(PROPERTY_HINT_NONE, "suffix:degrees") var max_steering_angle_slow := 10.0 # will be stat adjustable
@export_custom(PROPERTY_HINT_NONE, "suffix:degrees") var max_steering_angle_fast := 4.0 # will be state adjustable
@export_custom(PROPERTY_HINT_NONE, "suffix:degrees/s") var air_steering_velocity := 50.0
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var wheel_base := 1.5
@export var drift_multiplier := 1.5
@export var drift_buffer := 0.5 # time you have to input a direction after starting drift
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var drift_max_time := 5.0 # will be state adjustable
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var boost_max_time := 1.5 # will be state adjustable


var drift_buffer_timer : float # increment timer for drift
var just_started_drift : bool # check whether the kart should start the drift buffer
var drift_stage : int #level of drift
var drift_timer : float #increament timer for drift
var boost_timer : float #increament timer for boost
var boost_actual_speed : float #actual speed of boost

var steering : float = 0
var new_kart_rotation : Vector3 = Vector3.ZERO
var base_kart_rotation_y : float = 0.0
var current_model_up := Vector3.UP

var floor_angle : float
var up_speed : Vector3 #how fast you will go up
var capped_air_speed : float

var angular_velocity : float #how fast you're turning

#Crash Physics
var previous_velocity : Vector3
var reflected_velocity : Vector3
var crash_end_velocity : Vector3
var current_rotation : float 
var max_turn_angle : float

#Externals
var controls : PlayerControls
var kartCharacter : Character

enum states {
	DRIVE,
	AIR,
	CRASH
}
var state : states

func _handle_input() -> void:
	var move_vector := Input.get_vector(controls.turn_left,controls.turn_right,controls.backward,controls.forward)
	input_acceleration = move_vector.y
	input_steering = move_vector.x if abs(move_vector.x) > 0.05 else 0
	
	if Input.is_action_just_pressed(controls.drift) && velocity.length() > 0 && input_acceleration >= 0:
		input_drift = true
		drift_direction = 0
		
	if Input.is_action_just_released(controls.drift):
		input_drift = false
		drift_timer = 0.0
		if drift_stage == 1:
			set_boost(2, 2)
		if drift_stage == 2:
			set_boost(1.5, 2)
		if drift_stage == 3:
			set_boost(1.0, 1.0)
		
		_set_drifting_stage(-1)

#region Drift / Boost
func _drift_boost_control(delta : float) -> void:
	if input_drift and drift_direction == 0: # start drift buffer
		if drift_buffer_timer < drift_buffer:
			drift_direction = sign(input_steering)
			
			if drift_direction != 0: # started drifting in a direction
				_set_drifting_stage(0)
				drift_timer = 0.0
				
			drift_buffer_timer += delta
		else: # exit drift buffer and stop drfiting
			drift_buffer_timer = 0
			input_drift = false
			#just_started_drift = false
		return
		
		
	if input_drift and is_on_floor():
		drift_timer += abs(angular_velocity) * delta
		if drift_timer > drift_max_time/6 and drift_stage < 1:
			_set_drifting_stage(1)
		elif drift_timer > drift_max_time/2 and drift_stage < 2:
			_set_drifting_stage(2)
		elif drift_timer > drift_max_time and drift_stage < 3:
			_set_drifting_stage(3)
	
	if boost_timer > 0:
		boost_timer -= delta

func _set_drifting_stage(stage : int) -> void:
	for particle in particlesManager:
		particle.set_drifting_stage(stage)
	drift_stage = stage
	#print(drift_stage)

func set_boost(speedDivisor : float, timeDivisor : float) -> void:
	boost_actual_speed = top_speed + (boost_top_speed / speedDivisor)
	boost_timer = boost_max_time / timeDivisor
#endregion
	
func _get_horizontal_velocity() -> Vector3: 
	return Vector3(velocity.x, 0, velocity.z)

func _align_mesh_with_normal(_delta : float, normal : Vector3) -> void:
	var up := normal.normalized() # gets normal of new up
	var forward := -global_transform.basis.z # gets forward direction of kart
	forward = (forward - up * forward.dot(up)).normalized()
	
	var right := up.cross(forward).normalized() #get the right
	
	var new_basis := Basis()
	new_basis.x = right
	new_basis.y = up
	new_basis.z = forward
	
	kart_model.global_basis = new_basis
	kart_model.rotation += new_kart_rotation

func _ready() -> void:
	if self.get_parent() is Player:
		var player : Player = self.get_parent()
		controls = player.playerControls
	state = states.DRIVE

func _process(delta: float) -> void:
	base_kart_rotation_y = kart_model.rotation.y
	var new_up := Vector3.UP
	var t := 0.5
	
	if is_on_floor():
		new_up = get_floor_normal()
		t = 0.025
	else:
		var lean_strength := -0.2
		var up := Vector3.UP
		var forward : Vector3 = global_transform.basis.z
		var side := forward.cross(up)
		var vertical_velocity := velocity.dot(up)
		var lean_angle : float = clamp(vertical_velocity * lean_strength, -0.2, 0.5)
		new_up = up.rotated(side.normalized(), lean_angle)
		
	current_model_up = current_model_up.lerp(new_up, 1 - pow(t, 2 * delta)) #Smoothly transition to new up
	_align_mesh_with_normal(delta, current_model_up)
	
	_handle_input()
	_drift_boost_control(delta)
	Events.on_get_speed.emit(velocity.length(), drift_timer)
	
func _physics_process(delta: float) -> void:
	_apply_steering(delta)
	#_go_down_slopes(delta)
	#print(state)
	match(state):
		states.DRIVE:
			_drive_state(delta)
		states.AIR:
			_air_state(delta)
		states.CRASH:
			_crash_state(delta)
	
	DebugDraw.draw_line(global_position + Vector3(0,1,0), global_position + _get_horizontal_velocity() + Vector3(0,1,0), Color(0, 0.0, 255, 1.0))
	
#func _go_down_slopes(delta : float) -> void:
	##print(rad_to_deg(get_floor_angle()))
	#for shapecast in shapecasts:
		#if shapecast.is_colliding():
			#shapecast.force_raycast_update()
			#apply_floor_snap()
	
#region States
func _drive_state(delta : float) -> void:
	if is_on_floor():
		print(get_floor_normal())
		_apply_engine_force(delta)
		floor_angle = get_floor_angle()
	else:
		capped_air_speed = _get_horizontal_velocity().length()
		up_speed = Vector3(0, min(8, pow(floor_angle, 2) * velocity.length()), 0)
		state = states.AIR
	
	previous_velocity = _get_horizontal_velocity()
	move_and_slide()
	if is_on_wall():
		state = states.CRASH
	
func _air_state(delta : float) -> void:
	_apply_air_forces(delta)
	
	if is_on_floor():
		velocity.y = 0
		state = states.DRIVE
	
	move_and_slide()
	
func _crash_state(delta : float) -> void:
	_apply_wall_bounce(delta)
	move_and_slide()
	if round(velocity.length()) == round(crash_end_velocity.length()):
		max_turn_angle = 0
		reflected_velocity = Vector3.ZERO
		crash_end_velocity = Vector3.ZERO
		state = states.DRIVE

#endregion

#region Apply forces
func _apply_engine_force(delta : float) -> void:
	var forward := -global_transform.basis.z
	var horizontal_velocity := _get_horizontal_velocity()
	
	var speed := horizontal_velocity.length()
	var signed_speed := forward.dot(horizontal_velocity)
	horizontal_velocity = forward * signed_speed
	
	if sign(input_acceleration) != sign(signed_speed) and input_acceleration != 0 and sign(signed_speed) != 0:
		#brake
		horizontal_velocity = horizontal_velocity.move_toward(Vector3.ZERO, 1 - pow(0.5, break_resistance * delta))
	elif boost_timer > 0 and speed < boost_actual_speed:
		#boost
		horizontal_velocity += boost_acceleration * forward * delta
	elif input_acceleration > 0 && speed <= top_speed:
		#drive
		horizontal_velocity += input_acceleration * acceleration * forward * delta
	elif input_acceleration < 0 && speed <= reverse_top_speed:
		#reverse
		horizontal_velocity += input_acceleration * acceleration * forward * delta
	else:
		#drag
		horizontal_velocity = horizontal_velocity.lerp(Vector3.ZERO, 1 - pow(0.5, ground_resistance * delta))
		
	velocity = horizontal_velocity + Vector3.UP * velocity.y
	
func _apply_steering(delta : float) -> void:
	var forward := -global_transform.basis.z
	var horizontal_velocity := _get_horizontal_velocity()
	var speed : float = min(top_speed, horizontal_velocity.length() * sign(horizontal_velocity.dot(forward)))
	steering = lerp(steering, input_steering, 1 - pow(0.5, 60 * delta))
	
	angular_velocity = deg_to_rad(air_steering_velocity * steering)
	
	#Determines how far you're able to steer in one direction based on your speed
	var max_steering_angle : float = lerp(max_steering_angle_slow, max_steering_angle_fast, clamp(speed / top_speed, 0.0, 1.0))
	var avg_steering_angle : float = lerp(max_steering_angle_slow, max_steering_angle_fast, 1.0)
	
	var y_kart_rotation : float
	var steering_angle : float
	if is_on_floor():
		if input_drift: #drift steering angle
			# Drift_diretion will either be 1 or -1 and steering will be a range from -1 to 1. 
			# Constant for steering shouldn't be greater than constant for drift_direction
			steering_angle = drift_multiplier * max_steering_angle * (drift_direction * 0.4 + 0.38 * steering)
			y_kart_rotation = (drift_direction * 0.6 + 0.5 * steering) * 10 * deg_to_rad(avg_steering_angle)
		elif abs(speed) > 1e-2: #Non-drift steering angle
			steering_angle = max_steering_angle * steering
			y_kart_rotation = steering * 2 * deg_to_rad(max_steering_angle)
		angular_velocity = (speed * tan(deg_to_rad(steering_angle))) / wheel_base
		
	rotate_y(-delta * angular_velocity)
	
	#Model animations
	var final_kart_rotation := Vector3(0, -y_kart_rotation, steering * 2 * deg_to_rad(avg_steering_angle))
	new_kart_rotation = new_kart_rotation.lerp(final_kart_rotation, 1 - pow(0.8, 60 * delta)) #smoothly transition to new rotation
	#Debug numbers
	Events.on_get_steer.emit(steering_angle, max_steering_angle, angular_velocity)
	
func _apply_air_forces(delta : float) -> void:
	var forward : Vector3 = -global_transform.basis.z
	var horizontal_velocity := _get_horizontal_velocity()
	horizontal_velocity = forward * forward.dot(horizontal_velocity)
	var raw_velocity = horizontal_velocity + Vector3.UP * velocity.y + up_speed * delta
	velocity = capped_air_speed * raw_velocity.normalized() if capped_air_speed > 10 else raw_velocity
	capped_air_speed -= delta
	up_speed += gravity_acceleration * delta
	
func _apply_wall_bounce(delta : float) -> void:
	if is_on_wall():
		DebugDraw.draw_line(global_position + Vector3(0,1,0), global_position + get_wall_normal() + Vector3(0,1,0), Color(255, 0, 0))
		DebugDraw.draw_line(global_position + Vector3(0,1,0), global_position + previous_velocity.bounce(get_wall_normal()) + Vector3(0,1,0), Color(0, 255, 0))
		#Reflect velocity off wall
		reflected_velocity = previous_velocity.bounce(get_wall_normal())
		reflected_velocity.y = 0
		crash_end_velocity = reflected_velocity / 2
		#Determine if bounce should rotate player
		var perpendicular_to_collision_normal := previous_velocity.slide(get_wall_normal().normalized())
		var angle_between_wall_and_player := previous_velocity.angle_to(perpendicular_to_collision_normal)
		current_rotation = rotation.y
		#Only rotate if going forwards, at less than a 50deg angle, and not drifting
		if angle_between_wall_and_player < deg_to_rad(50) and previous_velocity.dot(-global_transform.basis.z) > 0 and !input_drift:
			max_turn_angle = previous_velocity.signed_angle_to(reflected_velocity, Vector3.UP)
	
	#rotation.y = lerp(rotation.y, current_rotation + max_turn_angle, pow(0.5, reflected_velocity.length() * delta))
	reflected_velocity = reflected_velocity.lerp(crash_end_velocity, 1 - pow(0.5, break_resistance * delta))
	velocity = reflected_velocity + Vector3.UP * velocity.y

#endregion
