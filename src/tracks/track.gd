class_name Track extends BaseLevel

@export var player_spawners: Array[Marker3D]

var lap_count: int
var checkpoint_list: Array
@export var willCountdown: bool = true # set to false to disable race countdown
signal countdown_finished

func update(laps: int, c_list: Array) -> void:
	lap_count = laps
	checkpoint_list = c_list
	print("TrackLapLogic: stuff has been updated")

func countdown(time: float, message: String) -> void:
	for n in range(time, 0, -1):
		print("TrackLapLogic: " + str(n))
		await get_tree().create_timer(1).timeout
	print("TrackLapLogic: " + message)
	
	countdown_finished.emit()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func get_default_player_spawn() -> Array[Marker3D]:
	return player_spawners

func get_player_camera() -> Camera3D:
	return null
