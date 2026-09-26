extends Node3D

@export var drift_required : int = 4

@onready var shortcutblock: Node3D = $shortcutblock


var tween : Tween

func _on_shortcut_collision_area_entered(area: Area3D) -> void:
	var num_of_spins := 10
	if area is SpinHitbox:
		var spinhitbox : SpinHitbox = area
		if spinhitbox.charge_level >= drift_required && spinhitbox.hitbox_active:
			spinhitbox.call_spin_boost()
			spinhitbox.hit_shortcut = true
			reset_tween()
			tween.tween_property(shortcutblock, "rotation_degrees", Vector3.ZERO, 0)
			tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(shortcutblock, "rotation_degrees", Vector3.UP * 360 * num_of_spins, 5.0)
		else: 
			spinhitbox.call_bounce()
	elif area is SpinHurtBox:
		var spinhurtbox : SpinHurtBox = area
		if !spinhurtbox.spinIntangiblility:
			spinhurtbox.call_bounce()
	

func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
