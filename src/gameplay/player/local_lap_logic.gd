class_name LocalLapLogic extends Area3D

var checks_needed : int # How many checkpoints are in the track (not counting StartLine)
var laps_done: int
var progress: Array
var check_order: Array
var race_timer: float = 0.0
var respawn_location: Vector3
var respawn_rotation: Vector3
@onready var player_controller: Node = %Kart_Sphere
@onready var player: Node = %Center

# All print statements from LapLogic scripts are prefaced with "LapLogic: " for easy output reading

# Adds 1 to the laps_done variable if player crossed every checkpoint
func complete_lap() -> void:
	if len(progress) == checks_needed and player_controller.isRacing:
		progress.clear()
		laps_done += 1
		print("LocalLapLogic: lap #" + str(laps_done) + " completed!! yay!!")
	else:
		progress.clear()
		print("LocalLapLogic: Player does not have enough progress")
	
	#does *something* when 3 laps have been done
	if laps_done == TrackInfo.lap_count:
		print("LocalLapLogic: Three laps have been completed! This player is out of the race!")
		player_controller.isRacing = false
		print("LocalLapLogic: Finish Time: " + str(snapped(race_timer, 0.001)))

# Adds the given id to the progress array if it is the proper id
func add_checkpoint(check_id: int) -> void:
	
	var _needed_check = check_order[progress.size()] # This is the value that we are looking for
	
	print("Comparing recieved ID: " + str(check_id) + "to the required ID: " + str(_needed_check))
	if check_id == _needed_check:
		progress.append(check_id)
		print("LocalLapLogic: Checkpoint #" + str(progress.size()) + " was crossed.")
	else:
		print("LocalLapLogic: Checkpoint ID: " + str(check_id) + " is not a valid checkpoint.")

# Tells each Player instance what the IDs of the checkpoints are
func get_check_order(order: Array) -> void:
	if len(check_order) == 0:
		check_order = order
		checks_needed = len(order)
		print("LocalLapLogic: kart has recieved checkpoint info")

func _on_tree_entered() -> void:
	await get_tree().create_timer(0.2).timeout # Gives time for TrackInfo to update
	get_check_order(TrackInfo.checkpoint_list)
	if TrackInfo.willCountdown:
		await get_tree().create_timer(4.8).timeout # Total of a 5 second wait from Scene Start
		player_controller.isRacing = true
	else:
		player_controller.isRacing = true

# Manages Timer
func _process(delta: float) -> void:
	if player_controller.isRacing:
		race_timer += delta
		Events.on_get_time.emit(snapped(race_timer, 0.001))

# Sets player position to the last checkpoint
# DysFUNCtional (haha get it) since I have yet to figure out positions
func respawn() -> void:
	player.global_position = respawn_location
	player.global_rotation = respawn_rotation
