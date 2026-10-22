class_name CPU extends Node
## Simulates player inputs using "Input.action_press" and "Input.action_release". Passes in inputs based on the positions of cpus

@onready var player: Player = $".."
@onready var center: Node3D = %Center
@onready var kart_sphere: Kart_Sphere = %Kart_Sphere

var controls : PlayerControls

# MOVE VECTOR KEY (x, y):
# x is sideways (left is negative, right is positive)
# y is vertical (forward is positive, back is negative)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player.playerId > (GameManager.players_connected - 1):
		print("Hey guys, I'm a CPU!")
		player.playerControlled = false

func _process(delta: float) -> void:
	turn_right()

func accelerate() -> void:
	kart_sphere.sim_move_vector = 1.0

func reverse() -> void:
	kart_sphere.sim_move_vector = -1.0

func turn_left() -> void:
	kart_sphere.sim_turn_vector = -1.0

func turn_right() -> void:
	kart_sphere.sim_turn_vector = 1.0
