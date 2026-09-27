class_name SpinHurtBox extends Area3D

@onready var shape_cast_3d: ShapeCast3D = %ShapeCast3D
@onready var kart_sphere: Kart_Sphere = %Kart_Sphere
var parent : Player
var spinIntangiblility := false

func _ready() -> void:
	parent = self.get_parent().get_parent()

func _on_area_entered(area: Area3D) -> void:
	if area is SpinHitbox:
		var spinhitbox : SpinHitbox = area
		if spinhitbox.hitbox_active and spinhitbox.parent != parent:
			if !spinIntangiblility:
				print("hit")
				call_knockback(spinhitbox.kart_sphere.kartCharacter.knockback)
				call_spin_hit_slowdown(spinhitbox.charge_level, spinhitbox.kart_sphere.kartCharacter.weight)
				spinhitbox.call_spin_boost()
				
	if area.get_collision_layer_value(8):
		kart_sphere.is_trailing = true
	
func _on_area_exited(area: Area3D) -> void:
	if area.get_collision_layer_value(8):
		kart_sphere.is_trailing = false
	
#func _physics_process(_delta: float) -> void:
	#if shape_cast_3d.is_colliding():
		#print("Colliding")
		#var area : Area3D = shape_cast_3d.get_collider(0)
		#print(area)
		#if area.get_collision_layer_value(8): # gets trailing object
			#kart_sphere.is_trailing = true
	#else:
		#kart_sphere.is_trailing = false

func call_knockback(opposing_knockback : float) -> void:
	shape_cast_3d.force_shapecast_update()
	if shape_cast_3d.is_colliding():
		print(to_local(shape_cast_3d.get_collision_point(0)))
		for i in shape_cast_3d.get_collision_count():
			var collision_point := to_local(shape_cast_3d.get_collision_point(i))
			kart_sphere.apply_clash_force(-collision_point, kart_sphere.knockback + (kart_sphere.kartCharacter.knockback - opposing_knockback)) 

func call_spin_hit_slowdown(drift_stage : int, opposing_weight : float) -> void:
	if drift_stage < 0:
		drift_stage = 0
	kart_sphere.spin_cooldown_timer = kart_sphere.spin_cooldown
	kart_sphere.apply_slowdown_force(kart_sphere.spin_hit_slowdown_amounts[drift_stage] + (kart_sphere.kartCharacter.weight - opposing_weight))
	kart_sphere.remove_drift_charge()
	
func call_slowdown(multiplier : float = 0.5) -> void:
	kart_sphere.apply_slowdown_force(multiplier)

func call_bounce(bounce : float = 8) -> void:
	kart_sphere.apply_bounce_force(bounce)

func apply_boost_panel_boost(boost_speed_multiplier : float, boost_time_multiplier : float) -> void: ## Applies speed boost and from boost panel
	kart_sphere.set_boost(boost_speed_multiplier, boost_time_multiplier)
	kart_sphere.start_store_charge_boost_panel_timer()
	if kart_sphere.drift_stage >= 3:
		kart_sphere.boost_panels_drifted_over += 1

#called by kartsphere
func setIntangiblility(state : bool) -> void:
	spinIntangiblility = state
