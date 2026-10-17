extends Area3D

@onready var timer: Timer = $Timer
@onready var hitbox: CollisionShape3D = $CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.one_shot = false
	Events.on_countdown_finished.connect(on_race_start)

func on_race_start() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	if hitbox.disabled:
		hitbox.disabled = false
	else:
		hitbox.disabled = true

func _on_area_entered(area: Area3D) -> void:
	if area is SpinHurtBox:
		area.call_slowdown()
