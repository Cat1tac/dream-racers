extends CollisionShape3D

#Progress Manager
signal lap_completed
signal checkpoint_crossed
var progress : Array[int] #Stores each checkpoint instance ID the player has passed

# When player crosses the start line, the lap count will be increased if enough progress has been made
# Nothing will happen if the player has not made enough progress
func complete_lap() -> void:
	lap_completed.emit(progress)
	print("LapLogic: crossed start line")

func add_checkpoint(cp_id: int) -> void:
	checkpoint_crossed.emit(cp_id, progress)

func race_started() -> bool:
	return true
