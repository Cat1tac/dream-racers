## Handles lap logic for each individual player/cpu
class_name LocalLapLogic extends Area3D

signal check_passed(path: int)
signal player_respawned(id: int)

var key_checkpoints_passed: Array[Checkpoint] ## Updating array of key checkpoints player has gone past
var respawn_checkpoints_passed : Dictionary[Checkpoint, int] ## Updating array of respawn checkpoints player has gone past
var respawn_checkpoints : Array[Checkpoint] ##Array of checkpoint player can respawn at (currently all checkpoints)
var key_checkpoints: Array[Checkpoint] ## Array of all key checkpoints
var laps_done: int ## number of laps completed

var race_timer: float = 0.0
var last_respawn_passed : Checkpoint
var respawn_location: Vector3
var respawn_rotation: Vector3

var playerControlled: bool = false

var start_line_position : Vector3
@onready var parent: Player = $"../.."
@onready var player_controller: Kart_Sphere = %Kart_Sphere
@onready var player: Node3D = %Center

# All print statements from LapLogic scripts are prefaced with "LapLogic: " for easy output reading

## Adds 1 to the laps_done variable if player crossed every checkpoint
func complete_lap() -> void:
	if len(key_checkpoints_passed) == len(key_checkpoints) and player_controller.isRacing:
		key_checkpoints_passed.clear()
		respawn_checkpoints_passed.clear()
		last_respawn_passed = null
		laps_done += 1
		Events.on_get_lap_count.emit(laps_done, parent.playerId)
		print("LocalLapLogic: lap #" + str(laps_done) + " completed!! yay!!")
	else:
		key_checkpoints_passed.clear()
		respawn_checkpoints_passed.clear()
		last_respawn_passed = null
		print("LocalLapLogic: Player does not have enough progress")
	
	#does *something* when 3 laps have been done
	if laps_done == parent.current_track.lap_count:
		Events.players_finished_race.emit()
		print("LocalLapLogic: Three laps have been completed! This player is out of the race!")
		player_controller.isRacing = false
		print("LocalLapLogic: Finish Time: " + str(snapped(race_timer, 0.001)))

## Adds checkpoint to the key_checkpoints_passed array
func add_checkpoint(checkpoint: Checkpoint) -> void:
	if !checkpoint.is_key_checkpoint:
		return
		
	if len(key_checkpoints) == len(key_checkpoints_passed):
		return
	
	var _next_key_checkpoint : Checkpoint = key_checkpoints[key_checkpoints_passed.size()] # This is the value that we are looking for
	check_passed.emit(key_checkpoints.find(checkpoint))
	
	print("Comparing recieved ID: " + str(checkpoint) + "to the required ID: " + str(_next_key_checkpoint))
	if checkpoint == _next_key_checkpoint:
		key_checkpoints_passed.append(checkpoint)
		print("LocalLapLogic: Checkpoint #" + str(key_checkpoints_passed.size()) + " was crossed.")
	else:
		print("LocalLapLogic: Checkpoint ID: " + str(checkpoint) + " is not a valid checkpoint.")

## Updates respawn point if it comes after the previous respawn point passed
func update_respawn_point(new_respawn_point : Checkpoint) -> void:
	if respawn_checkpoints_passed.has(new_respawn_point): # if point has been logged then return 
		return
	
	#Compare id of respawn point to last one logged and if its less than it then it will return
	var new_respawn_point_id : int = respawn_checkpoints.find(new_respawn_point)
	if last_respawn_passed != null and respawn_checkpoints_passed.has(last_respawn_passed) and respawn_checkpoints_passed[last_respawn_passed] > new_respawn_point_id:
		return
	 
	last_respawn_passed = new_respawn_point
	respawn_location = last_respawn_passed.res_point.global_position
	respawn_rotation = last_respawn_passed.res_point.global_rotation
	respawn_checkpoints_passed[last_respawn_passed] = new_respawn_point_id

## Sets player position to the last checkpoint
func respawn() -> void:
	if parent.current_track == null:
		return
	player_controller.global_position = respawn_location
	player.global_rotation = respawn_rotation
	player_controller.linear_velocity = Vector3(0.0, 0.0, 0.0)
	player_respawned.emit(parent.playerId)

func _ready() -> void:
	Events.on_send_checkpoints.connect(_get_all_checkpoints)
	Events.on_countdown_finished.connect(_start_player_race)
	Events.on_starting_respawn.connect(_initial_respawn)
	playerControlled = parent.playerControlled
	Events.get_start_line_position.connect(set_start_line_position)

# Manages Timer
func _process(delta: float) -> void:
	if player_controller.isRacing:
		race_timer += delta
		Events.on_get_time.emit(snapped(race_timer, 0.001))
	#print("LalLogic: " + str(self.global_rotation_degrees))

	## use playerId to set score individually
	GameManager.player_list[parent.playerId].score = calculate_score()
	

##Puts key checkpoints and respawn checkpoints into their own arrays
func _get_all_checkpoints(checkpoint_array: Array[Checkpoint]) -> void:
	for checkpoint in checkpoint_array:
		if checkpoint.is_key_checkpoint:
			key_checkpoints.append(checkpoint)
	respawn_checkpoints = checkpoint_array
	print("LocalLapLogic: kart has received checkpoint info")
	
#region Scoring/Placement Data
## Uses the .distance_to function to get the distance to the next key checkpoint from the player
func get_distance_to_next_key_checkpoint(kart : Kart_Sphere) -> float:
	# on last checkpoint get distance to start line
	if key_checkpoints_passed.size() == key_checkpoints.size():
		return start_line_position.distance_to(kart.global_position) 
		
	elif key_checkpoints_passed.size() > 0:
		return key_checkpoints[key_checkpoints_passed.size()].global_position.distance_to(kart.global_position)
	# before first key checkpoint
	else:
		return key_checkpoints[0].global_position.distance_to(kart.global_position)

func get_current_checkpoint() -> int:
	# starting value
	if key_checkpoints_passed.size() == 0:
		return 0
	
	#print(key_checkpoints_passed.size())
	return key_checkpoints_passed.size()

## laps * amount of checkpoints + current checkpoint
func calculate_score() -> float:
	return self.laps_done * key_checkpoints.size() + get_current_checkpoint()

func set_start_line_position(position: Vector3) -> void:
	start_line_position = position

#endregion
##Sets isRacing to true
func _start_player_race() -> void:
	player_controller.isRacing = true

func _initial_respawn(start_line : Marker3D) -> void:
	respawn_location = start_line.global_position
	respawn_rotation = start_line.global_rotation
