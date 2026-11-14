class_name Item extends Node3D

@export var animation_player : AnimationPlayer
@export var sfx : SFX

@export var animation : StringName
## changes boost timer by this amount, can set timer above normal max
## how long the item will stay despawned
@export var despawn_length: float = 1
## boost level to set kart to (behaves as if the kart chaged to this amount normally)
@export var set_boost_lvl : Kart_Sphere.BOOST_LEVEL

@export var area_3d: Area3D
var collision_shape : CollisionShape3D

enum SFX {
	MINI,
	BIG
}

var despawn_increment : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play(animation)
	collision_shape = area_3d.get_child(0) as CollisionShape3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if despawn_increment > 0:
		despawn_increment -= delta
	else:
		self.show()
		collision_shape.disabled = false
		despawn_increment = 0
			
func _physics_process(_delta: float) -> void:
	if area_3d.area_entered:
		for area in area_3d.get_overlapping_areas():
			if area is SpinHurtBox:
				_do_item_effect(area as SpinHurtBox)
	
func _do_item_effect(area : SpinHurtBox) -> void:
	despawn_increment = despawn_length
	self.hide()
	collision_shape.disabled = true
	
	var kart : Kart_Sphere = area.kart_sphere
	if sfx == SFX.MINI:
		kart.audio_player.play_audio(kart.audio_player.SFX.MINI)
	else:
		kart.audio_player.play_audio(kart.audio_player.SFX.BIG)
		
	if set_boost_lvl > kart.BOOST_LEVEL.ZERO:
		kart.execute_boost(set_boost_lvl, false, false, true, true)
