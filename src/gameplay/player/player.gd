class_name Player extends Node3D

@export var playerControls : PlayerControls
@export var character : Character
@export var kart_model_scene: PackedScene
@export var boostChargeArray : Array[KartParticlesManager]
@onready var camera_pivot: Marker3D = $CameraPivot
@onready var second_camera: Marker3D = %SecondCamera

@onready var kart_sphere: Kart_Sphere = $Kart_Sphere
@onready var center: Node3D = %Center

var playerId : int
var sphere_offset := 0.5
var kart_model_instance : Model

var selected_camera : Camera3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_change_camera($CameraPivot/Camera3D)
	kart_model_instance = kart_model_scene.instantiate()
	center.add_child(kart_model_instance)
	
	for i in range(len(kart_model_instance.charge_markers)):
		boostChargeArray[i].reparent(kart_model_instance.charge_markers[i])
		boostChargeArray[i].global_position = kart_model_instance.charge_markers[i].global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Rotates cameras to match back and side of car
	camera_pivot.rotation.y = lerp_angle(camera_pivot.rotation.y, center.rotation.y, 1 - pow(0.5, 60 *delta)) 
	second_camera.rotation.y = lerp_angle(second_camera.rotation.y, center.rotation.y + deg_to_rad(90), 1 - pow(0.5, 60 *delta)) 
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if selected_camera == $CameraPivot/Camera3D:
			_change_camera($SecondCamera/Camera3D)
		else:
			_change_camera($CameraPivot/Camera3D)
	
	# keeps center and camera on same point as sphere rigidbody
	center.global_position = kart_sphere.global_position
	#kart_model.global_position.y = center.global_position.y - sphere_offset
	camera_pivot.global_position = center.global_position
	second_camera.global_position = center.global_position

func _change_camera(camera: Camera3D) -> void:
	print(camera.get_parent())
	selected_camera = camera
	selected_camera.make_current()
