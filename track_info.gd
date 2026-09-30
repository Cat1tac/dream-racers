extends Node

var lap_count: int
var checkpoint_list: Array
signal countdown_finished

func update(laps: int, c_list: Array) -> void:
	lap_count = laps
	checkpoint_list = c_list
	print("GlobalLapLogic: shit has been updated")

func countdown(time: float, message: String) -> void:
	for n in range(time, 0, -1):
		print("GlobalLapLogic: " + str(n))
		await get_tree().create_timer(1).timeout
	print("GlobalLapLogic: " + message)
	
	countdown_finished.emit()
