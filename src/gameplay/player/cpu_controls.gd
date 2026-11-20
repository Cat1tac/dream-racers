class_name CPU extends Node
## Simulates player inputs using "Input.action_press" and "Input.action_release". Passes in inputs based on the positions of cpus

@onready var player : Player = $".."
@onready var kart_sphere : Kart_Sphere = %Kart_Sphere
@onready var hitbox : Area3D = %SpinHitbox
@onready var center : Node3D = %Center
@onready var cpu_spin_sensor: Area3D = %CpuSpinSensor
@onready var spin_hitbox: SpinHitbox = %SpinHitbox
@onready var spin_hurt_box: SpinHurtBox = %SpinHurtBox


var controls : PlayerControls

var cpu_checkpoints_passed: Array[CPUArea]
var cpu_checkpoints: Array[CPUArea]
var next_checkpoint: int = 0

var cpuTricked: bool = false
var drift_direction: String = "NONE"

var offset : float ## offsets cpu from center so they don't bunch up
var position_to_target : Vector3 ## Stores the offseted position
var spin_chance : float
var speed_adjust : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spin_chance = randf_range(0.4, 0.9)
	if player.playerId > (GameManager.players_connected - 1):
		player.playerControlled = false
		Events.on_countdown_finished.connect(play)
		Events.on_send_cpu_positions.connect(set_cpu_checkpoint_array)

# Decision Making (Also sometimes called 'Artificial Intelligence' or something)
func _process(_delta: float) -> void:
	if kart_sphere.currentState == kart_sphere.STATES.RACING and !player.playerControlled: # Has the CPU started racing?
		var forward := -center.global_basis.z
		var position := center.global_position
		#print(position_to_target)
		var checkpoint_direction := position.direction_to(position_to_target)
		if checkpoint_direction.dot(forward) > 0.92: # Is CPU facing the checkpoint?
			cancel_turn()
			stop_drift()
		else:
			var right_vector := -center.global_basis.x
			if right_vector.dot(checkpoint_direction) < 0:
				if right_vector.dot(checkpoint_direction) < -0.4:
					start_drift("RIGHT")
				if drift_direction == "LEFT":
					cancel_turn()
				turn_right()
			else:
				if right_vector.dot(checkpoint_direction) > 0.4:
					start_drift("LEFT")
				if drift_direction == "RIGHT":
					cancel_turn()
				turn_left()
		
		# Attempts a trick if CPU is in the air
		if !kart_sphere.on_ground() and !cpuTricked:
			cpuTricked = true
			spin()
		elif kart_sphere.on_ground():
			cpuTricked = false
		
# Sets the CPU in motion on RaceStart
func play(_delay : int) -> void:
	accelerate()

#region Movement Functions
# MOVE VECTOR KEY (x, y):
# x is sideways (left is negative, right is positive)
# y is vertical (forward is positive, back is negative)

func accelerate() -> void:
	kart_sphere.sim_move_vector = 1.0

func reverse() -> void:
	kart_sphere.sim_move_vector = -1.0

func stop() -> void:
	kart_sphere.sim_move_vector = 0.0

# Timer parameters existed for hard-coding instructions but i'll keep them in case we need them
func turn_left(timer: float = 0.0) -> void:
	kart_sphere.sim_turn_vector = -1.0
	if timer != 0.0:
		await get_tree().create_timer(timer).timeout
		cancel_turn()

func turn_right(timer: float = 0.0) -> void:
	kart_sphere.sim_turn_vector = 1.0
	if timer != 0.0:
		await get_tree().create_timer(timer).timeout
		cancel_turn()

func cancel_turn() -> void:
	kart_sphere.sim_turn_vector = 0.0

# NOW IS THAT TIME LADIES GENTLEMEN AND EVERYONE IN-BETWEEN
func spin() -> void:
	kart_sphere.sim_spinInput = true

func stop_spin() -> void:
	kart_sphere.sim_spinInput = false

func start_drift(drift_dir: String) -> void:
	if !kart_sphere.input_drift: #Makes sure the CPU only triggers a "pressed" interaction once
		kart_sphere.simulate_drift_change(true)
		drift_direction = drift_dir

func stop_drift() -> void:
	if kart_sphere.input_drift: #Makes sure the CPU only triggers a "released" interaction once
		kart_sphere.simulate_drift_change(false)
	drift_direction = "NONE"

#endregion

## Updates the checkpoint rotation the CPU refers to
func _on_local_lap_logic_check_passed(check: CPUArea, id : int) -> void:
	if id != player.playerId or player.playerControlled:
		return
	var cpu_area_index := cpu_checkpoints.find(check)
	if cpu_area_index + 1 >= len(cpu_checkpoints):
		next_checkpoint = 0
	else:
		next_checkpoint = cpu_area_index + 1
	
	if kart_sphere.currentState == kart_sphere.STATES.RACE_START:
		next_checkpoint = 1
		await Events.on_send_cpu_positions
		
	# Get offset of cpu from center of cpu area that is clamped by radius
	var area : CylinderShape3D = cpu_checkpoints[next_checkpoint].collision_shape_3d.shape
	offset = randf_range(-((area.radius/2) - 2), (area.radius/2) - 2)
	position_to_target = cpu_checkpoints[next_checkpoint].to_global(cpu_checkpoints[next_checkpoint].collision_shape_3d.position + (Vector3.RIGHT * offset))

## Gives the CPU the rotation of all checkpoints
func set_cpu_checkpoint_array(check_arr: Array[CPUArea]) -> void:
	cpu_checkpoints = check_arr

func _on_cpu_spin_sensor_area_entered(area: Area3D) -> void:
	if kart_sphere.currentState == kart_sphere.STATES.RACE_START:
		return
	
	if area == spin_hitbox or area == spin_hurt_box:
		print("we not spinning!")
		return
		
	var rand_num := randf_range(0, 1)
	if rand_num < spin_chance:
		if area is SpinHitbox or area is SpinHurtBox:
			await get_tree().create_timer(randf_range(0.05, 0.2)).timeout
		spin()
		
