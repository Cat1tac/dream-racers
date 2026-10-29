class_name CPU extends Node
## Simulates player inputs using "Input.action_press" and "Input.action_release". Passes in inputs based on the positions of cpus

@onready var player: Player = $".."
@onready var kart_sphere: Kart_Sphere = %Kart_Sphere
@onready var hitbox: Area3D = %SpinHitbox

var controls : PlayerControls

var checkpoint_rotations: Array
var current_checkpoint: int = 0

## Inverts steering if radian differences cross over the 3.14 limit
var invertControls: bool = false

# MOVE VECTOR KEY (x, y):
# x is sideways (left is negative, right is positive)
# y is vertical (forward is positive, back is negative)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player.playerId > (GameManager.players_connected - 1):
		player.playerControlled = false
		Events.on_countdown_finished.connect(play)

# Decision Making (Also sometimes called 'Artificial Intelligence' or whatever)
func _process(delta: float) -> void:
	if kart_sphere.isRacing and !player.playerControlled:
		
		# Double checks rotation values to account for radians ranging from -3.14 to 3.14
		if abs(hitbox.global_rotation.y - checkpoint_rotations[current_checkpoint]) > 3.14:
			invertControls = true
		else:
			invertControls = false
		
		# CPU only turns if its own rotation doesn't match the next checkpoint's rotation
		if hitbox.global_rotation.y >= checkpoint_rotations[current_checkpoint] - 0.05 and hitbox.global_rotation.y <= checkpoint_rotations[current_checkpoint] + 0.05:
			cancel_turn()
		elif hitbox.global_rotation.y > checkpoint_rotations[current_checkpoint]:
			if invertControls:
				turn_left()
			else:
				turn_right()
		else:
			if invertControls:
				turn_right()
			else:
				turn_left()

# Sets the CPU in motion on RaceStart
func play() -> void:
	accelerate()

#region Movement Functions

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

# Soon... not yet, but soon...
func spin() -> void:
	kart_sphere.sim_spinInput = true

#endregion

## Updates the checkpoint rotation the CPU refers to
func _on_local_lap_logic_check_passed() -> void:
	if current_checkpoint + 1 == len(checkpoint_rotations):
		current_checkpoint = 0
	else:
		current_checkpoint += 1

# The 2nd Cousin 3 times removed of get_check_order() from LocalLapLogic
## Gives the CPU the rotation of all checkpoints
func get_check_rotations(arr: Array) -> void:
	checkpoint_rotations = arr

func _on_tree_entered() -> void:
	await Events.on_checkpoints_list_filled # Gives time for TrackInfo to update
	if !player.current_track:
		await get_tree().create_timer(0.1).timeout
		get_check_rotations(player.current_track.checkpoint_rotations)
	else:
		get_check_rotations(player.current_track.checkpoint_rotations)
	print()
