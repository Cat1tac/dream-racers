class_name Trail_Object extends Node3D

@onready var timer: Timer = $Timer
var spawn_position : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = spawn_position

func _on_timer_timeout() -> void:
	queue_free()
