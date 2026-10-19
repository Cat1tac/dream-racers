class_name CPU extends Node
## Simulates player inputs using "Input.action_press" and "Input.action_release". Passes in inputs based on the positions of cpus

@onready var player: Player = $".."
@onready var center: Node3D = %Center
@onready var kart_sphere: Kart_Sphere = %Kart_Sphere

var controls : PlayerControls

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	controls = player.playerControls
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
