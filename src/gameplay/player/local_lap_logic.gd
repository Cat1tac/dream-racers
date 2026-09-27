class_name LocalLapLogic extends Area3D

var checks_needed : int = 5 # How many checkpoints are in the track (not counting StartLine)
var laps_done: int
var progress: Array
var check_order: Array
var isRacing: bool = true

# All print statements from LapLogic scripts are prefaced with "LapLogic: " for easy output reading

# Adds 1 to the laps_done variable if player crossed every checkpoint
func complete_lap() -> void:
	if len(progress) == checks_needed:
		progress.clear()
		laps_done += 1
		print("LapLogic: lap #" + str(laps_done) + " completed!! yay!!")
	else:
		print("LapLogic: Player does not have enough progress")
	
	#does *something* when 3 laps have been done
	if laps_done == 3:
		print("LapLogic: Three laps have been completed! This player is out of the race!")
		isRacing = false

# Adds the given id to the progress array if it is the proper id
func add_checkpoint(check_id: int) -> void:
	
	var _needed_check = check_order[progress.size()] # This is the value that we are looking for
	
	print("Comparing recieved ID: " + str(check_id) + "to the required ID: " + str(_needed_check))
	if check_id == _needed_check:
		progress.append(check_id)
		print("LapLogic: Checkpoint ID: " + str(check_id) + " is a valid checkpoint!")
		print("LapLogic: Checkpoint #" + str(progress.size()) + " was crossed.")
	else:
		print("LapLogic: Checkpoint ID: " + str(check_id) + " is not a valid checkpoint.")

# Checks if the race has "started" by seeing if any progress has been made
# lwk bandage fix but we rock w/ it right?
func race_started() -> bool:
	if laps_done == 0 and len(progress) == 0: 
		return false
	else: 
		return true

# Used by BIG LapLogic to tell each instance what the IDs of the checkpoints are
func get_check_order(order: Array) -> void:
	if len(check_order) == 0:
		print("LapLogic: kart has recieved order of checkpoints")
		check_order = order
