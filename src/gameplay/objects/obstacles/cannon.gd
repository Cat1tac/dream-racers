extends StaticBody3D

@onready var timer: Timer = $Timer

var ball_scene = preload("res://src/gameplay/objects/cannonball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.on_countdown_finished.connect(on_start)

func on_start() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	var temp_ball = ball_scene.instantiate()
	add_child(temp_ball)
