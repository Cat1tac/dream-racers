extends Control
@onready var speed_num: Label = $CanvasLayer/VBoxContainer/SpeedHeader/SpeedNum
@onready var acceleration_num: Label = $CanvasLayer/VBoxContainer/AccelerationHeader/AccelerationNum
@onready var steering_angle_num: Label = $CanvasLayer/VBoxContainer/Steering/SteeringAngleNum
@onready var max_steering_num: Label = $CanvasLayer/VBoxContainer/max_steering_angle/max_steering_Num
@onready var angular_velocity_num: Label = $CanvasLayer/VBoxContainer/angular_velocity/angular_velocity_num
@onready var drifttimer_num: Label = $CanvasLayer/VBoxContainer/DriftTimerHeader/DrifttimerNum
@onready var time_elapsed_num: Label = $CanvasLayer/VBoxContainer/time_elapsed/time_elapsed_Num


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.on_get_steer.connect(displaySteerInfo)
	Events.on_get_speed.connect(displaySpeedInfo)
	Events.on_get_time.connect(displayTimeInfo)

func displaySpeedInfo(speed : float, drift_timer : float, id : int = 1) -> void:
	speed_num.text = str(speed)
	drifttimer_num.text = str(drift_timer)

func displaySteerInfo(steer : float, max_steer : float, angular_vel : float)  -> void:
	steering_angle_num.text = str(steer)
	max_steering_num.text = str(max_steer)
	angular_velocity_num.text = str(angular_vel)

func displayTimeInfo(time: float) -> void:
	time_elapsed_num.text = str(time)
