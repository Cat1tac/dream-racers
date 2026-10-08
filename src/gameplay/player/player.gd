class_name Player extends Node3D

@export var playerControls : PlayerControls
@export var kart_model_scene: PackedScene
@export var boostChargeArray : Array[KartParticlesManager]

@onready var camera_pivot: CameraPivot = $CameraPivot
@onready var second_camera: Marker3D = %SecondCamera
@onready var kart_sphere: Kart_Sphere = $Kart_Sphere
@onready var center: Node3D = %Center

var current_track : Track
var playerId : int
var sphere_offset := 0.5
var kart_model_instance : Model
var kart_stats : Stats

var selected_camera : Camera3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_change_camera($CameraPivot/Camera3D)
	kart_model_instance = kart_model_scene.instantiate() as Model
	kart_model_instance.current_state = kart_model_instance.STATE.IN_RACE
	kart_stats = kart_model_instance.stats
	center.add_child(kart_model_instance)
	
	for i in range(len(kart_model_instance.charge_markers)):
		boostChargeArray[i].reparent(kart_model_instance.charge_markers[i])
		boostChargeArray[i].global_position = kart_model_instance.charge_markers[i].global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Rotates cameras to match back and side of car
	camera_pivot.rotation.y = lerp_angle(camera_pivot.rotation.y, center.rotation.y, 1 - pow(0.5, 60 *delta)) 
	second_camera.rotation.y = lerp_angle(second_camera.rotation.y, center.rotation.y + deg_to_rad(90), 1 - pow(0.5, 60 *delta)) 
	_align_camera_to_floor_normal()
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if selected_camera == $CameraPivot/Camera3D:
			_change_camera($SecondCamera/Camera3D)
		else:
			_change_camera($CameraPivot/Camera3D)
	
	# keeps center and cameras on same point as sphere rigidbody
	center.global_position = kart_sphere.global_position
	camera_pivot.global_position = center.global_position
	second_camera.global_position = center.global_position

func _change_camera(camera: Camera3D) -> void:
	print(camera.get_parent())
	selected_camera = camera
	selected_camera.make_current()
	
func _align_camera_to_floor_normal() -> void:
	var floor_normal := kart_sphere.get_floor_normal()
	
	var up := floor_normal.normalized()
	if floor_normal == Vector3.ZERO:
		up = Vector3.UP
	
	var forward := (center.global_basis.z).normalized()
	forward = (forward - up * forward.dot(up)).normalized()
	var right := up.cross(forward).normalized()
	
	var new_basis : Basis
	new_basis.x = right
	new_basis.y = up
	new_basis.z = forward
	
	camera_pivot.tween_new_basis(new_basis)
