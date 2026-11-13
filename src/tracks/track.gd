class_name Track extends BaseLevel

@export var player_spawners: Array[Marker3D]
@export var lap_logic : LapLogic
@export var lap_count : int = 3
@export var willCountdown: bool = false # set to false to disable race countdown

const MAIN_MENU : String = "uid://dt5xamoe48268"
var checkpoints: Array[Checkpoint]
var checkpoint_positions: Array #is this being used?
var checkpoint_rotations: Array

var num_players_finished : int
var delay : int = 10 # frames

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoints = lap_logic.get_checkpoints() 
	Events.on_send_checkpoints.emit(checkpoints)
	Events.on_get_total_laps.emit(lap_count)
	Events.on_starting_respawn.emit(lap_logic.respawn_point)
	Events.players_finished_race.connect(race_over)

func countdown(time: float) -> void:
	for n in range(time, 0, -1):
		Events.on_get_countdown.emit(n, delay)
		await get_tree().create_timer(1).timeout
	
	Events.on_countdown_finished.emit(delay)

func race_over() -> void:
	num_players_finished += 1
	if num_players_finished == GameManager.players_connected:
		Events.on_race_over.emit()
		await get_tree().create_timer(8).timeout # delay until return to main menu
		GameManager.reset_selections()
		GameManager.toggle_in_match()
		GameManager.remove_all_cpus()
		GameManager.load_into_path(MAIN_MENU)

# NOTE DEBUG
#func _process(_delta: float) -> void:
	#if Input.is_key_pressed(KEY_1):
		#race_over()
	
func get_default_player_spawn() -> Array[Marker3D]:
	return player_spawners

func get_player_camera() -> Camera3D:
	return null
