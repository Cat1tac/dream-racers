extends StaticBody3D

@onready var timer: Timer = $Timer
@onready var slam_area: Area3D = $SlamBox
@onready var still_area: Area3D = $BounceBox

@onready var slam_box: CollisionShape3D = $SlamBox/CollisionShape3D
@onready var still_box1: CollisionShape3D = $BounceBox/CollisionShape3D
@onready var still_box2: CollisionShape3D = $BounceBox/CollisionShape3D2
@onready var still_box3: CollisionShape3D = $BounceBox/CollisionShape3D3

# Stage 0 = Resting; Stage 1 = Slam/Impact; Stage 2 = Rising/Post-Slam
var stage: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.one_shot = true
	Events.on_countdown_finished.connect(on_race_start)

# Starts timer for piston loop
func on_race_start() -> void:
	timer.start(5.0)

# Progresses Piston Stage and calls relevant functions
func _on_timer_timeout() -> void:
	increase_stage()
	move_piston(stage)
	update_timer(stage)

# Disable/Enable piston hitbox depending on stage
func move_piston(s: int) -> void:
	match s:
		0:
			slam_box.disabled = true
			still_box1.disabled = true
			still_box2.disabled = true
			still_box3.disabled = true
		1:
			slam_box.disabled = false
			still_box1.disabled = false
			still_box2.disabled = false
			still_box3.disabled = false
		2:
			slam_box.disabled = true
			still_box1.disabled = false
			still_box1.disabled = false
			still_box1.disabled = false

# Cycles through 3 Stages for Piston
func increase_stage() -> void:
	stage += 1
	if stage > 2:
		stage = 0

# Changes timing of stages
func update_timer(n: int) -> void:
	match n:
		0:
			timer.start(5.0)
		1:
			timer.start(1.0)
		2:
			timer.start(4.0)

func _on_slam_box_area_entered(area: Area3D) -> void:
	if area is SpinHurtBox:
		area.call_slowdown(1.0)

func _on_still_box_area_entered(area: Area3D) -> void:
	if area is SpinHurtBox:
		area.call_bounce()
