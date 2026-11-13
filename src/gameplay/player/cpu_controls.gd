class_name CPU extends Node
## Simulates player inputs using "Input.action_press" and "Input.action_release". Passes in inputs based on the positions of cpus

@onready var player: Player = $".."
@onready var kart_sphere: Kart_Sphere = %Kart_Sphere
@onready var hitbox: Area3D = %SpinHitbox
@onready var center: = %Center

var controls : PlayerControls

var checkpoint_positions: Array #TODO change all instances of this var to match the refactored lap system
var current_checkpoint: int = 0

## Inverts steering if radian differences cross over the 3.14 limit
var invertControls: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player.playerId > (GameManager.players_connected - 1):
		player.playerControlled = false
		Events.on_countdown_finished.connect(play)
	Events.on_send_check_positions.connect(get_check_positions)

# Decision Making (Also sometimes called 'Artificial Intelligence' or whatever)
func _process(delta: float) -> void:
	
	if kart_sphere.isRacing and !player.playerControlled:
		var forward = -center.global_basis.z
		var position = center.global_position
		var checkpoint_direction = position.direction_to(checkpoint_positions[current_checkpoint])
		if checkpoint_direction.dot(forward) > 0.92:
			cancel_turn()
		else:
			var right_vector = -center.global_basis.x
			if right_vector.dot(checkpoint_direction) < 0:
				turn_right()
			else:
				turn_left()
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

#endregion

## Updates the checkpoint rotation the CPU refers to
func _on_local_lap_logic_check_passed(check_index: int) -> void:
	if check_index + 1 >= len(checkpoint_positions):
		current_checkpoint = 0
	else:
		current_checkpoint = check_index + 1

## Gives the CPU the rotation of all checkpoints
func get_check_positions(arr: Array) -> void:
	checkpoint_positions = arr

func _on_tree_entered() -> void:
	await Events.on_checkpoints_list_filled # Gives time for TrackInfo to update
	if !player.current_track:
		await get_tree().create_timer(0.1).timeout
		get_check_positions(player.current_track.checkpoint_positions)
	else:
		get_check_positions(player.current_track.checkpoint_positions)
	print()
