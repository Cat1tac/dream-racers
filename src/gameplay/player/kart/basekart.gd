class_name Model extends Node3D

@onready var kart: Node3D = %kart
@export var charge_markers : Array[Marker3D]
@export var boost_markers : Array[Marker3D]
@export var stats : Stats

# Controls animation for player
@export var animation_tree : AnimationTree

@export var skeleton : Skeleton3D

enum STATE {
	IN_RACE,
	IN_CHARACTER_SELECT
} 

@export var current_state : STATE

#region in-race
var tween : Tween
var num_spins : int = 2

var kart_scale : Vector3
var kart_model_scale : Vector3
var _turning_position : float = 0.0 #For turning the character
@export var tricking : bool #for determinin if character is tricking 
#endregion

#region character select
var selected : bool
#endregion

func _ready() -> void:
	kart_scale = scale
	kart_model_scale = kart.scale
	
	_duplicate_shader()
	
func _process(_delta: float) -> void:
	match current_state:
		STATE.IN_CHARACTER_SELECT: 
			_handle_in_character_select_logic()
		STATE.IN_RACE:
			_handle_in_race_logic(_delta)
	
			
func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()

func _duplicate_shader() -> void:
	for child : MeshInstance3D in skeleton.get_children():
		for i in child.get_surface_override_material_count():
			var duplicated_material = child.get_surface_override_material(i).duplicate_deep()
			child.set_surface_override_material(i, duplicated_material)

#region In Character Select
func _handle_in_character_select_logic() -> void:
	pass
#endregion

#region In Race
func _handle_in_race_logic(_delta : float) -> void:
	if !tween or !tween.is_running():
		if kart.global_rotation != global_rotation:
			kart.global_rotation = kart.global_rotation.slerp(global_rotation, 1 - pow(0.025, 2 * _delta))
		else:
			kart.global_rotation = global_rotation
	
func do_trick_anim() -> void:
	_reset_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(set_model_global_rotation, kart.global_rotation, Vector3(global_rotation.x + (TAU * num_spins), global_rotation.y, global_rotation.z + (TAU * (num_spins - 1))) , 0.8)
	tricking = true
	await tween.finished
	tricking = false
	
func do_grow_anim(end_scale : Vector3) -> void:
	_reset_tween()
	tween.tween_property(kart, "scale", end_scale, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(kart, "scale", kart_model_scale, 0.3)
	
func set_model_global_rotation(current_rotation : Vector3) -> void:
	kart.global_rotation = current_rotation
	
func steer_character(direction : float, drifting : bool, delta : float) -> void:
	var drifting_amt := 0.0 if !drifting else 0.5
	var max_steer := direction * (0.5 + drifting_amt)
	_turning_position = lerp(_turning_position, max_steer, 1 - pow(0.5, 60 * delta)) 
	animation_tree["parameters/In Race/Driving/Turning/blend_position"] = _turning_position
	
#endregion
