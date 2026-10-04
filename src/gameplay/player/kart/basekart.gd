class_name Model extends Node3D

@onready var kart: Node3D = %kart
@export var charge_markers : Array[Marker3D]

# Controls animatios for player
@export var animation_tree : AnimationTree

enum STATE {
	IN_RACE,
	IN_CHARACTER_SELECT
} 

@export var current_state : STATE

var tween : Tween
var num_spins : int = 2

var kart_scale : Vector3
var _turning_position : float = 0.0 #For turning the character
@export var _tricking : bool #for determinin if character is tricking 


func _ready() -> void:
	kart_scale = scale

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
	_tricking = true
	await tween.finished
	_tricking = false
	
func set_model_global_rotation(current_rotation : Vector3) -> void:
	kart.global_rotation = current_rotation
	
func steer_character(direction : float, drifting : bool, delta : float) -> void:
	var drifting_amt := 0.0 if !drifting else 0.5
	var max_steer := direction * (0.5 + drifting_amt)
	_turning_position = lerp(_turning_position, max_steer, 1 - pow(0.5, 60 * delta)) 
	animation_tree["parameters/In Race/Driving/Turning/blend_position"] = _turning_position
	
#endregion
