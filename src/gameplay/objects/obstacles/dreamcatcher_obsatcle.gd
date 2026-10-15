extends Node3D

@onready var dreamcatcher: Node3D = $dreamcatcher
var net : MeshInstance3D
var spin : bool

var tween : Tween

func _ready() -> void:
	net = dreamcatcher.get_child(0)

func _on_dreamcatcher_hurt_box_area_entered(area: Area3D) -> void:
	var num_of_spins := 10
	if area is SpinHitbox:
		var spinhitbox : SpinHitbox = area
		spinhitbox.call_spin_boost()
		spinhitbox.hit_dreamcatcher = true
	elif area is SpinHurtBox:
		var spinhurtbox : SpinHurtBox = area
		if !spinhurtbox.spinIntangiblility:
			spinhurtbox.call_slowdown()
			num_of_spins = 4
		
	
	
	reset_tween()
	tween.tween_property(net, "rotation_degrees", Vector3.ZERO, 0)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(net, "rotation_degrees", Vector3.UP * 360 * num_of_spins, 5.0)

func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
