class_name SpinHitbox extends Area3D

@export var spinhurtbox : SpinHurtBox

@onready var kart_sphere: Kart_Sphere = %Kart_Sphere
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var shape_cast_3d: ShapeCast3D = %ShapeCast3D


var parent : Player
var hitbox_active := false
var charge_level : int
var hit_dreamcatcher := false
var hit_shortcut := false

var collision_point : Vector3

func _ready() -> void:
	parent = self.get_parent().get_parent()

#called by kart_sphere
func set_active(state : bool) -> void:
	collision_shape_3d.disabled = !state
	hitbox_active = state
	
#called by dreamcatcher
func call_spin_boost() -> void:
	print(charge_level)
	kart_sphere.dreamcatcher_spin_boost()

#called by dreamcatcher
func call_bounce(bounce : float = 8) -> void:
	kart_sphere.apply_bounce_force(bounce)

func _process(delta: float) -> void:
	DebugDraw.draw_line(global_position, to_global(Vector3(-collision_point.x, collision_point.y, -collision_point.z)), Color(177.84, 24.316, 93.229, 1.0))

func _on_area_entered(area: Area3D) -> void:
	if area is SpinHitbox:
		shape_cast_3d.force_shapecast_update()
		if shape_cast_3d.is_colliding():
			print(to_local(shape_cast_3d.get_collision_point(0)))
			for i in shape_cast_3d.get_collision_count():
				collision_point = to_local(shape_cast_3d.get_collision_point(i))
				kart_sphere.apply_clash_force(-collision_point)
