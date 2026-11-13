extends Node3D

@export var bounce_height : float = 15
@export var charge_need_for_super_bounce : float = 4
## Used instead of normal forward boost
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s") var trick_forward_speed : float = 50.0
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s") var normal_forward_speed : float = 40.0
@export var shortcut_endpoint : Marker3D
## Controls how fast kart will be boosted up on super jump. Should be in frames
@export_custom(PROPERTY_HINT_NONE, "suffix:frames") var vertical_time : float = 120

## Controls how fast kart will be boosted forward on super jump. Should be in frames
@export_custom(PROPERTY_HINT_NONE, "suffix:frames") var forward_time : float = 110
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var cloud: Node3D = $cloud

var tween : Tween

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area is SpinHurtBox:
		var hurt_box : SpinHurtBox = area
		hurt_box.call_vertical_bounce(bounce_height)
		if hurt_box.kart_sphere.tricked: # if tricked beforehand, recieve an extra boost of speed
			hurt_box.kart_sphere.apply_target_forward_speed(trick_forward_speed) #if negative will turn slowdown into boost
			hurt_box.kart_sphere.execute_boost(1, false)
		else:
			hurt_box.kart_sphere.apply_target_forward_speed(normal_forward_speed)
		_bounce()
		hurt_box.reset_trick()
		


func _on_area_3d_area_exited(area: Area3D) -> void:
	audio_stream_player_3d.play()
	await get_tree().create_timer(0.2).timeout
	if area is SpinHurtBox:
		var hurt_box : SpinHurtBox = area
		if hurt_box.kart_sphere.current_boost_level >= charge_need_for_super_bounce and charge_need_for_super_bounce > -1 and hurt_box.kart_sphere.tricked:
			hurt_box.kart_sphere.apply_point_vertical_force(shortcut_endpoint.global_position, vertical_time, get_physics_process_delta_time())
			hurt_box.kart_sphere.apply_point_forward_force(shortcut_endpoint.global_position, forward_time, get_physics_process_delta_time())

func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	
func _bounce() -> void:
	_reset_tween()
	tween.tween_property(cloud, "scale", Vector3(cloud.scale.x, 0.8, cloud.scale.z), 0.1)
	tween.tween_property(cloud, "scale", Vector3(cloud.scale.x, 1.0, cloud.scale.z), 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
