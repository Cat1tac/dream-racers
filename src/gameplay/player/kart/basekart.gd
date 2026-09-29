class_name Model extends Node3D

@onready var kart: Node3D = %kart

@export var charge_markers : Array[Marker3D]

var tween : Tween
var num_spins : int = 2

var new_basis : Basis
var kart_scale : Vector3

func _ready() -> void:
	kart_scale = scale

func _process(_delta: float) -> void:
	if !tween or !tween.is_running():
		if kart.global_rotation != global_rotation:
			kart.global_rotation = kart.global_rotation.slerp(global_rotation, 1 - pow(0.025, 2 * _delta))
		else:
			kart.global_rotation = global_rotation

func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()

func do_trick_anim() -> void:
	_reset_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(set_model_global_rotation, kart.global_rotation, Vector3(global_rotation.x + (TAU * num_spins), global_rotation.y, global_rotation.z + (TAU * (num_spins - 1))) , 0.8)
	
func set_model_global_rotation(current_rotation : Vector3) -> void:
	kart.global_rotation = current_rotation
	print(kart.global_rotation)
