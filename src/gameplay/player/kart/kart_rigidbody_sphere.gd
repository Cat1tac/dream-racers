class_name Kart_Sphere extends RigidBody3D
## Handles all movement and phsyics interaction dealing with the kart
@export var ground_cast : RayCast3D
@export var snap_cast : RayCast3D
@export var wall_cast : ShapeCast3D
@export var particlesManager : Array[KartParticlesManager]
#@onready var kart_model: Node3D = $Kart_Model
@onready var center: Node3D = %Center
@onready var kart_model: Node3D = %KartModel
@onready var spin_hitbox: SpinHitbox = %SpinHitbox
@onready var spin_hurt_box: SpinHurtBox = %SpinHurtBox
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

#Inputs
var input_acceleration : float
var input_steering : float
var input_drift : bool
var input_spin : bool

var drift_direction : float

@export_group("Speed")
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s") var top_speed := 20.0 # Will be stat adjustable
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s") var reverse_top_speed := 7.5
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s^2") var acceleration := 5.0 # Will be stat adjustable

@export var brake_resistance := 10 ## How much resistance there is to forward movement when pressing in the opposite direction of the velocity
@export var ground_resistance := 3 ## How mcuh resistance there is to forward movement when coasting

@export_group("Steering")
@export_custom(PROPERTY_HINT_NONE, "suffix:degrees") var max_steering_angle_slow := 10.0 # will be stat adjustable
@export_custom(PROPERTY_HINT_NONE, "suffix:degrees") var max_steering_angle_fast := 4.0 # will be state adjustable
@export_custom(PROPERTY_HINT_NONE, "suffix:degrees/s") var air_steering_velocity := 50.0
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var wheel_base := 1.5
@export_range(0, 1) var traction_factor := 0.3 ## The factor by which the car will slide when turning (0 is no traction, 1 is no slide) (Starts to lose speed while drifitng when traction is less then 0.3)  
@export var drift_multiplier := 1.5 ## Mulitplier for how much drifting influences turn angle
@export var drift_buffer := 0.5 ## Time player has to input a direction after starting drift
@export var snake_buffer := 0.2 ## Time you have to change drift direction after releasing drift
@export var drift_charge_curve : Curve

@export_group("Spin")
@export var spin_length := 1.0 ## How long the spin will last
@export var spin_curve : Curve
@export var spin_cooldown : float = 1.0 ## Time until player can use spin again
@export var spin_hit_slowdown_amounts : Dictionary = { ## How much the player is slowed when hit by a spin
	0: 0.85,
	1: 0.75,
	2: 0.65,
	3: 0.55,
	4: 0.45,
	5: 0.35,
	6: 0.15
}
@export var knockback : float = 10 ## Hoow much the player is knocked back when hit by a spin

@export_group("Boost")
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s^2") var boost_acceleration := 21.0
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s") var boost_top_speed : = 5.0
@export var boosts : Dictionary = { ## Dictionary containing divisors for drift boost speed/time and spin boost speed/time
	1:{"dftSpdFactor" : 0.5, "dftTimeFactor" : 0.5, "spinSpdFactor" : 0.3, "spinTimeFactor" : 0.4},
	2:{"dftSpdFactor" : 0.7, "dftTimeFactor" : 0.7, "spinSpdFactor" : 0.4, "spinTimeFactor" : 0.4},
	3:{"dftSpdFactor" : 1, "dftTimeFactor" : 1, "spinSpdFactor" : 0.5, "spinTimeFactor" : 0.5},
	4:{"dftSpdFactor" : 1.2, "dftTimeFactor" : 1.2, "spinSpdFactor" : 0.6, "spinTimeFactor" : 0.6},
	5:{"dftSpdFactor" : 1.5, "dftTimeFactor" : 1.5, "spinSpdFactor" : 0.7, "spinTimeFactor" : 0.7},
	6:{"dftSpdFactor" : 1.8, "dftTimeFactor" : 1.8, "spinSpdFactor" : 0.8, "spinTimeFactor" : 0.8}}
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var boost_max_time := 1.5 # will be state adjustable
#TODO Implement a boost curve

var drift_just_released : bool #bool for if the kart just released drift button
var drift_buffer_timer : float # increment timer for drift
var snake_buffer_timer : float # increment timer for snaking
var just_started_drift : bool # check whether the kart should start the drift buffer
var drift_stage : int #level of drift
var drift_timer : float #increament timer for drift
var new_drift_timer_base : float #new base timer to start from after snaking
var boost_timer : float #increament timer for boost
var boost_actual_speed : float #actual speed of boost
var boost_panels_drifted_over : int = 0

var spin_timer : float
var spin_top_speed_multiplicand : float
var spin_cooldown_timer : float
var speed_right_before_spin : float 
var dreamcatcher_boost : float
var dreamcatcher_boost_timer : float
var dreamcatcher_acceleration : float

var steering : float = 0
var new_kart_rotation : Vector3 = Vector3.ZERO
var base_kart_rotation_y : float = 0.0
var current_model_up := Vector3.UP
var angular_speed : float
var ground_y_rotation : float
var air_y_rotation : float

var floor_angle : float
var capped_air_speed : float


#Crash Physics
var previous_velocity : Vector3
var reflected_velocity : Vector3
var crash_end_velocity : Vector3
var current_rotation : float 
var max_turn_angle : float

#Externals
var controls : PlayerControls
var kartCharacter : Character
var parent : Player

var kart_scale : Vector3

enum states {
	DRIVE,
	AIR,
	CRASH
}
var state : states

#region raycast funcs
func on_ground() -> bool:
	ground_cast.force_raycast_update()
	return true if ground_cast.is_colliding() else false

func body_colliding_with_ground() -> bool:
	for body in get_colliding_bodies():
		if body.get_collision_layer_value(2) or body.get_collision_layer_value(3):
			return true
	return false

func get_floor_normal() -> Vector3:
	if on_ground():
		return ground_cast.get_collision_normal()
	return Vector3.ZERO
	
func on_wall() -> bool:
	if wall_cast.is_colliding():
		return true
	return false
	
func get_wall_normal() -> Vector3:
	if on_wall():
		return wall_cast.get_collision_normal(0)
	return Vector3.ZERO
#endregion

func _handle_input() -> void:
	var move_vector := Input.get_vector(controls.turn_left,controls.turn_right,controls.backward,controls.forward)
	input_acceleration = move_vector.y
	input_steering = move_vector.x if abs(move_vector.x) > 0.05 else 0

	if Input.is_action_just_pressed(controls.drift) && linear_velocity.length() > 0 && input_acceleration >= 0:
		input_drift = true
		drift_direction = 0
		
	if Input.is_action_just_released(controls.drift):
		input_drift = false
		drift_just_released = true
		 
	if Input.is_action_just_pressed(controls.spin):
		if spin_cooldown_timer <= 0:
			spin_hitbox.hit_dreamcatcher = false
			spin_hurt_box.setIntangiblility(true)
			var forward := -center.global_basis.z
			speed_right_before_spin = forward.dot(linear_velocity) if forward.dot(linear_velocity) < top_speed else top_speed
			#apply_slowdown_force(0.25)
			input_spin = true


#region Drift / Boost
func _drift_boost_control(delta : float) -> void:
	if drift_just_released: #Controls Drift Boost release and snaking
		
		if snake_buffer_timer < snake_buffer:
			if input_drift:
				drift_direction = sign(input_steering)
				
				if drift_direction != 0:
					drift_timer = new_drift_timer_base if drift_timer - 0.3 < new_drift_timer_base else drift_timer - 0.35 
					drift_just_released = false 
					snake_buffer_timer = 0.0
			snake_buffer_timer += delta
		else:
			_execute_drift_boost()
	else: #Controls Initial Drift buffer
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
			return
		
	#Controls Drift Charge
	if input_drift and on_ground():
		drift_timer += abs(angular_speed + kartCharacter.drift_charge_speed) * delta
		#Base boost
		if drift_timer > drift_charge_curve.get_point_position(1).x and drift_stage < 1:
			new_drift_timer_base = drift_charge_curve.get_point_position(1).x
			_set_drifting_stage(1)
		elif drift_timer > drift_charge_curve.get_point_position(2).x and drift_stage < 2:
			new_drift_timer_base = drift_charge_curve.get_point_position(2).x
			_set_drifting_stage(2)
		elif drift_timer > drift_charge_curve.max_value and drift_stage < 3:
			new_drift_timer_base = drift_charge_curve.max_value
			_set_drifting_stage(3)
		
		#Boost panel boost
		if drift_stage >= 3:
			if boost_panels_drifted_over == 1 and drift_stage < 4:
				_set_drifting_stage(4)
			elif boost_panels_drifted_over == 3 and drift_stage < 5:
				_set_drifting_stage(5)
			elif boost_panels_drifted_over == 6 and drift_stage < 6:
				_set_drifting_stage(6)
		
	#Boost timer Countdown
	if boost_timer > 0:
		boost_timer -= delta

func _set_drifting_stage(stage : int) -> void:
	for particle in particlesManager:
		particle.set_drifting_stage(stage)
	drift_stage = stage
	spin_hitbox.drift_stage = stage
	#print(boost_panels_drifted_over)

func _execute_drift_boost() -> void: 
	var boostlevel : int = drift_stage
	if boostlevel > 0:
		var speedMultiplier : float = boosts[boostlevel]["dftSpdFactor"]
		var timeMultiplier : float = boosts[boostlevel]["dftTimeFactor"]
		set_boost(speedMultiplier, timeMultiplier)
	
	remove_drift_charge()

func set_boost(speedMultiplier : float, timeMultiplier : float) -> void:
	boost_actual_speed = top_speed + (boost_top_speed * speedMultiplier)
	boost_timer = boost_max_time * timeMultiplier
	
func remove_drift_charge() -> void:
	_set_drifting_stage(-1)
	drift_just_released = false
	snake_buffer_timer = 0.0
	drift_timer = 0.0
	new_drift_timer_base = 0.0
	boost_panels_drifted_over = 0
#endregion

#region Spin
## Executes spin and controls spin cooldown
func _do_spin(delta : float) -> void:
	if spin_cooldown_timer > 0:
		spin_cooldown_timer -= delta
	
	if input_spin:
		if spin_timer < spin_length:
			new_kart_rotation = Vector3.UP * lerp_angle(new_kart_rotation.y, spin_curve.sample(spin_timer), 1 - pow(0.2, 60 * delta))  
			spin_timer += delta
		else:
			spin_cooldown_timer = spin_cooldown * 0.5
			spin_timer = 0.0
			input_spin = false
			spin_hurt_box.setIntangiblility(false)
			if !spin_hitbox.hit_dreamcatcher:
				spin_cooldown_timer = spin_cooldown
				remove_drift_charge()
				
	spin_hitbox.set_active(input_spin)
			
	if dreamcatcher_boost_timer > 0:
		dreamcatcher_boost_timer -= delta
	else:
		dreamcatcher_boost = 0
		dreamcatcher_acceleration = 0
		
func dreamcatcher_spin_boost() -> void:
	var boostlevel : int = drift_stage
	if boostlevel < 1:
		boostlevel = 1
		
	var speedMultiplier : float = boosts[boostlevel]["spinSpdFactor"]
	var timeMultiplier : float = boosts[boostlevel]["spinTimeFactor"]
	_set_dreamcatcher_boost(speedMultiplier, timeMultiplier)
		
func _set_dreamcatcher_boost(speedMultiplier : float, timeMultiplier : float) -> void:
	dreamcatcher_boost = boost_top_speed * speedMultiplier
	dreamcatcher_boost_timer = boost_max_time * timeMultiplier
	dreamcatcher_acceleration = boost_acceleration - acceleration
#endregion

func _align_mesh_with_normal(_delta : float, normal : Vector3) -> void:
	var up := normal.normalized() # gets normal of new up
	var forward := center.global_basis.z # gets forward direction of kart
	forward = (forward - up * forward.dot(up)).normalized()
	
	var right := up.cross(forward).normalized() #get the right
	
	var new_basis := Basis()
	new_basis.x = right
	new_basis.y = up
	new_basis.z = forward
	
	
	snap_cast.global_basis = new_basis.orthonormalized()
	
	wall_cast.global_basis = new_basis.orthonormalized()
	
	spin_hitbox.global_basis= new_basis.orthonormalized()
	
	spin_hurt_box.global_basis = new_basis.orthonormalized()
	
	kart_model.global_basis = new_basis
	kart_model.rotation += new_kart_rotation
	kart_model.scale = kart_scale

func set_up_kart_stats() -> void:
	top_speed += kartCharacter.speed
	acceleration += kartCharacter.acceleration
	max_steering_angle_fast += kartCharacter.max_steering_angle_fast
	max_steering_angle_slow += kartCharacter.max_steering_angle_slow
	traction_factor += kartCharacter.traction_factor
	drift_multiplier += kartCharacter.drift_multiplier
	
	boost_top_speed += kartCharacter.boost_top_speed
	#drift_charge_speed (in the drift_boost_control function)
	boost_max_time += kartCharacter.boost_time

#region imbedded functions
func _ready() -> void:
	if self.get_parent() is Player:
		var player : Player = self.get_parent()
		controls = player.playerControls
		kartCharacter = player.character
		if kartCharacter:
			set_up_kart_stats()
		
	state = states.DRIVE
	kart_scale = kart_model.scale
	contact_monitor = true
	max_contacts_reported = 2

func _process(delta: float) -> void:
	#base_kart_rotation_y = kart_model.rotation.y
	var new_up := Vector3.UP
	var t := 0.5
	
	if on_ground():
		new_up = get_floor_normal()
		t = 0.025
	else:
		var lean_strength := -0.2
		var up := Vector3.UP
		var forward : Vector3 = center.global_basis.z
		var side := forward.cross(up)
		var vertical_velocity := linear_velocity.dot(up)
		var lean_angle : float = clamp(vertical_velocity * lean_strength, -0.2, 0.5)
		new_up = up.rotated(side.normalized(), lean_angle)
		
	current_model_up = current_model_up.lerp(new_up, 1 - pow(t, 2 * delta)) #Smoothly transition to new up
	_align_mesh_with_normal(delta, current_model_up)
	
	_handle_input()
	_drift_boost_control(delta)
	#Events.on_get_speed.emit(velocity.length(), drift_timer)
	
func _physics_process(delta: float) -> void:
	if on_ground():
		apply_central_force(-get_gravity() * mass)
		if !body_colliding_with_ground():
			_apply_grounded_snap_force(delta)
			print("snapping")
		else:
			print("not snapping")
		if !input_acceleration and linear_velocity.length() < 0.5:
			_apply_stop(delta)
		else:
			_apply_forward_force(delta)

	_apply_traction(delta)
	_apply_steering(delta)
	_do_spin(delta)
	
#endregion
	
#region forces
## When the player drives into a dreamcatcher without spinning or get hit they will slowdown 
func apply_slowdown_force(slowdown_factor : float) -> void:
	var forward := -center.global_basis.z
	var vel := forward.dot(linear_velocity)
	var force_vector : Vector3 = -forward * (vel * slowdown_factor) * mass
	apply_central_impulse(force_vector)
	
##Bounces car back when hitting a shortcut wall
func apply_shortcut_stop_force() -> void:
	var forward := -center.global_basis.z
	var vel := forward.dot(linear_velocity)
	var force_vector : Vector3 = -forward * (vel + 8) * mass
	apply_central_impulse(force_vector)
	
func apply_clash_force(collision_point : Vector3, knockback : float = 0) ->  void:
	var forward := -center.global_basis.z
	var fwd_vel := forward.dot(linear_velocity)
	
	var side := center.global_basis.x

	if knockback == 0:
		knockback = fwd_vel
		 
	var force_vector : Vector3 = side * min(collision_point.x * knockback, top_speed) * mass
	apply_central_impulse(force_vector)
	
func _apply_forward_force(_delta : float) -> void:
	var forward := -center.global_basis.z
	var up := get_floor_normal().normalized() # gets normal of new up
	forward = (forward - up * forward.dot(up)).normalized()
	var vel := forward.dot(linear_velocity)
	var force_vector : Vector3
	
	if sign(input_acceleration) != sign(vel) and input_acceleration != 0 and sign(vel) != 0:
		#brake
		force_vector = -forward * brake_resistance * signf(vel) * mass
	elif boost_timer + dreamcatcher_boost_timer > 0 and abs(vel) < boost_actual_speed + dreamcatcher_boost:
		#boost
		force_vector = boost_acceleration * forward * mass
	elif input_spin and !dreamcatcher_boost and boost_timer <= 0:
		#spin
		if abs(vel) < speed_right_before_spin * 0.8:
			force_vector = input_acceleration * acceleration * forward * mass
		else:
			force_vector = -forward * ground_resistance * 1.3 * signf(vel) * mass
	elif input_acceleration > 0 && abs(vel) < top_speed + dreamcatcher_boost:
		#forward
		force_vector = input_acceleration * (acceleration + dreamcatcher_acceleration) * forward * mass
	elif input_acceleration < 0 && abs(vel) < reverse_top_speed:
		#backward
		force_vector = input_acceleration * acceleration * forward * mass
	elif abs(vel) > 0.05:
		#drag
		if input_drift:
			#don't lose as much speed while drifting and not accelerating
			force_vector = -forward * (ground_resistance/2.0) * signf(vel) * mass
		else:
			force_vector = -forward * ground_resistance * signf(vel) * mass
	apply_central_force(60 * ((force_vector) * _delta))
	print(force_vector)
	DebugDraw.draw_line(global_position, global_position + force_vector, Color(0.0, 0.0, 255, 1.0))
	Events.on_get_speed.emit(vel, drift_timer)

func _apply_steering(delta : float) -> void:
	#center.rotate_y(0.1 * input_steering)
	var forward := -center.global_basis.z
	var horizontal_velocity := forward.dot(linear_velocity)
	var speed : float = min(top_speed, horizontal_velocity)
	steering = lerp(steering, input_steering, 1 - pow(0.5, 60 * delta))
	
	angular_speed = deg_to_rad(air_steering_velocity * steering)
	
	#Determines how far you're able to steer in one direction based on your speed
	var max_steering_angle : float = lerp(max_steering_angle_slow, max_steering_angle_fast, clamp(speed / top_speed, 0.0, 1.0))
	var avg_steering_angle : float = lerp(max_steering_angle_slow, max_steering_angle_fast, 1.0)
	
	var y_kart_rotation : float
	air_y_rotation = ground_y_rotation
	var steering_angle : float
	if on_ground():
		if input_drift: #drift steering angle
			# Drift_diretion will either be 1 or -1 and steering will be a range from -1 to 1. 
			# Constant for steering shouldn't be greater than constant for drift_direction 
			steering_angle = drift_multiplier * max_steering_angle * (drift_direction * 0.4 + 0.2 * steering)
			y_kart_rotation = (drift_direction * 0.6 + 0.5 * steering) * 10 * deg_to_rad(avg_steering_angle)
			if input_acceleration == 0:
				#drift more sharply if not accelerating
				steering_angle *= 1.15
		else: #abs(speed) > 1e-2: #Non-drift steering angle
			steering_angle = max_steering_angle * steering
			y_kart_rotation = steering * 2 * deg_to_rad(max_steering_angle) 
		
		var dot_between_wall_and_player := get_wall_normal().dot(forward)
		if on_wall() && dot_between_wall_and_player < 0 && speed < 5: #allow for greater turning while on the wall and at low speed
			var wall_turn_speed := 7 * (1 + dot_between_wall_and_player)
			angular_speed = wall_turn_speed * tan(deg_to_rad(steering_angle)) / wheel_base
		else:
			angular_speed = (speed * tan(deg_to_rad(steering_angle))) / wheel_base
		ground_y_rotation = y_kart_rotation
		
	else: # in air
		air_y_rotation += steering * deg_to_rad(max_steering_angle)
		y_kart_rotation = air_y_rotation
		
	center.rotate_y(-delta * angular_speed)
	
	#Model animations
	if !input_spin:
		var final_kart_rotation := Vector3(0, -y_kart_rotation, steering * 2 * deg_to_rad(avg_steering_angle))
		new_kart_rotation = new_kart_rotation.lerp(final_kart_rotation, 1 - pow(0.8, 60 * delta)) #smoothly transition to new rotation
	#TODO Move kart body z seperately from wheels and have wheels rotate in direction of turn
	#Debug numbers
	Events.on_get_steer.emit(steering_angle, max_steering_angle, angular_speed)

func _apply_traction(delta : float) -> void:
	var side := center.global_basis.x
	var side_speed := side.dot(linear_velocity)
	
	#how much acceleration the kart needs to end up at 0 in one physics step
	var instant_side_accel : float = (0.0 - side_speed) / delta
	
	var side_force := instant_side_accel * mass

	var limited_side_force := side_force * traction_factor
	DebugDraw.draw_line(global_position, global_position + (side * side_speed), Color(121.386, 2.061, 120.434, 1.0))
	DebugDraw.draw_line(global_position, global_position + (side * limited_side_force), Color(186.332, 3.187, 184.871, 1.0))
	apply_central_force(side * limited_side_force)

func _apply_stop(delta : float) -> void:
	var forward := -center.global_basis.z
	var forward_speed := forward.dot(linear_velocity)
	
	var side := center.global_basis.x
	var side_speed := side.dot(linear_velocity)
	
	var up := center.global_basis.y
	var up_speed := up.dot(linear_velocity)
	
	var instant_stop_accel : Vector3 = Vector3(0.0 - side_speed, 0.0 - up_speed, 0.0 - forward_speed) / delta
	
	var stop_force := ((side * instant_stop_accel.x) + (up * instant_stop_accel.y) + (forward * instant_stop_accel.z)) * mass
	
	apply_central_force(stop_force)
	
func _apply_grounded_snap_force(delta : float) -> void:
	var up := get_floor_normal()
	var up_speed := up.dot(linear_velocity)
	#get position of raycast subtracted by radius of sphere and it contact point with the ground
	
	snap_cast.force_raycast_update()
	var raypos := snap_cast.global_position 
	var ray_contact_point := snap_cast.get_collision_point()
	var ray_length : float = raypos.distance_to(ray_contact_point) - collision_shape_3d.shape.radius
	
	var instant_down_accel : float = 2 * (ray_length - up_speed * delta) / delta
	var limited_down_accel : float = min(150, instant_down_accel) #300 is how fast it can go before it clips through ground
	var down_force := -(limited_down_accel * mass)
	
	apply_central_force(up * down_force)
#endregion
