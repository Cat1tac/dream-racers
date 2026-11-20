class_name CPU extends Node
## Simulates player inputs using "Input.action_press" and "Input.action_release". Passes in inputs based on the positions of cpus

@onready var player: Player = $".."
@onready var kart_sphere: Kart_Sphere = %Kart_Sphere
@onready var hitbox: Area3D = %SpinHitbox
@onready var center: = %Center

var controls : PlayerControls

var checkpoint_positions: Array[Vector3]
var checkpoints: Array
var current_checkpoint: int = 0

var cpuTricked: bool = false
var drift_direction: String = "NONE"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player.playerId > (GameManager.players_connected - 1):
		player.playerControlled = false
		Events.on_countdown_finished.connect(play)
		Events.on_send_cpu_positions.connect(get_check_positions)

# Decision Making (Also sometimes called 'Artificial Intelligence' or something)
func _process(delta: float) -> void:
	
	if kart_sphere.isRacing and !player.playerControlled: # Has the CPU started racing?
		var forward = -center.global_basis.z
		var position = center.global_position
		var checkpoint_direction = position.direction_to(checkpoint_positions[current_checkpoint])
		if checkpoint_direction.dot(forward) > 0.92: # Is CPU facing the checkpoint?
			cancel_turn()
			stop_drift()
		else:
			var right_vector = -center.global_basis.x
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
func play() -> void:
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
func _on_local_lap_logic_check_passed(check: CPUArea) -> void:
	var check_index = checkpoints.find(check)
	
	if check_index + 1 >= len(checkpoint_positions):
		current_checkpoint = 0
	else:
		current_checkpoint = check_index + 1

## Gives the CPU the rotation of all checkpoints
func get_check_positions(arr: Array, check_arr: Array) -> void:
	checkpoint_positions = arr
	checkpoints = check_arr
	

func _on_tree_entered() -> void:
	await Events.on_checkpoints_list_filled # Gives time for TrackInfo to update
	if !player.current_track:
		await get_tree().create_timer(0.1).timeout
		get_check_positions(player.current_track.checkpoint_positions, player.current_track.cpu_checks)
	else:
		get_check_positions(player.current_track.checkpoint_positions, player.current_track.cpu_checks)
